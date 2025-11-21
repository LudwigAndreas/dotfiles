#!/usr/bin/env python3
"""
Properties to YAML Converter
A simple CLI tool to convert .properties files to YAML format
"""

import sys
import argparse
from pathlib import Path
from typing import Dict, Any


def parse_properties(content: str) -> Dict[str, Any]:
    """Parse properties file content into a dictionary"""
    props = {}
    
    for line in content.splitlines():
        line = line.strip()
        
        # Skip empty lines and comments
        if not line or line.startswith('#') or line.startswith('!'):
            continue
        
        # Find the separator (= or :)
        sep_idx = -1
        for i, char in enumerate(line):
            if char in ('=', ':') and (i == 0 or line[i-1] != '\\'):
                sep_idx = i
                break
        
        if sep_idx == -1:
            # No separator found, treat as key with empty value
            key = line.strip()
            value = ''
        else:
            key = line[:sep_idx].strip()
            value = line[sep_idx + 1:].strip()
        
        # Remove quotes if present
        if value.startswith('"') and value.endswith('"'):
            value = value[1:-1]
        elif value.startswith("'") and value.endswith("'"):
            value = value[1:-1]
        
        # Handle escaped characters
        value = value.replace('\\n', '\n').replace('\\t', '\t').replace('\\\\', '\\')
        
        # Try to convert to appropriate type
        if value.lower() == 'true':
            value = True
        elif value.lower() == 'false':
            value = False
        elif value.isdigit():
            value = int(value)
        elif value.replace('.', '', 1).replace('-', '', 1).isdigit():
            try:
                value = float(value)
            except ValueError:
                pass
        
        # Handle nested keys (e.g., database.host -> nested dict)
        if '.' in key:
            parts = key.split('.')
            current = props
            for part in parts[:-1]:
                if part not in current:
                    current[part] = {}
                elif not isinstance(current[part], dict):
                    # Convert to dict if not already
                    current[part] = {'_value': current[part]}
                current = current[part]
            current[parts[-1]] = value
        else:
            props[key] = value
    
    return props


def dict_to_yaml(data: Dict[str, Any], indent: int = 0) -> str:
    """Convert dictionary to YAML string"""
    yaml_lines = []
    indent_str = '  ' * indent
    
    for key, value in data.items():
        if isinstance(value, dict):
            yaml_lines.append(f"{indent_str}{key}:")
            yaml_lines.append(dict_to_yaml(value, indent + 1))
        elif isinstance(value, bool):
            yaml_lines.append(f"{indent_str}{key}: {str(value).lower()}")
        elif isinstance(value, (int, float)):
            yaml_lines.append(f"{indent_str}{key}: {value}")
        elif isinstance(value, str):
            # Handle multiline strings
            if '\n' in value:
                yaml_lines.append(f"{indent_str}{key}: |")
                for line in value.split('\n'):
                    yaml_lines.append(f"{indent_str}  {line}")
            # Quote strings with special characters
            elif any(c in value for c in [':', '#', '[', ']', '{', '}', ',', '&', '*', '!', '|', '>', '%', '@', '`']):
                yaml_lines.append(f"{indent_str}{key}: \"{value}\"")
            else:
                yaml_lines.append(f"{indent_str}{key}: {value}")
        else:
            yaml_lines.append(f"{indent_str}{key}: {value}")
    
    return '\n'.join(yaml_lines)


def convert_properties_to_yaml(input_file: Path, output_file: Path = None, flatten: bool = False):
    """Convert a properties file to YAML"""
    
    # Read properties file
    try:
        content = input_file.read_text(encoding='utf-8')
    except Exception as e:
        print(f"Error reading file {input_file}: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Parse properties
    props = parse_properties(content)
    
    # If flatten is True, don't create nested structure
    if flatten:
        flat_props = {}
        def flatten_dict(d, prefix=''):
            for k, v in d.items():
                if isinstance(v, dict):
                    flatten_dict(v, f"{prefix}{k}.")
                else:
                    flat_props[f"{prefix}{k}"] = v
        flatten_dict(props)
        props = flat_props
    
    # Convert to YAML
    yaml_content = dict_to_yaml(props)
    
    # Determine output file
    if output_file is None:
        output_file = input_file.with_suffix('.yaml')
    
    # Write YAML file
    try:
        output_file.write_text(yaml_content, encoding='utf-8')
        print(f"✓ Converted: {input_file} → {output_file}")
    except Exception as e:
        print(f"Error writing file {output_file}: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description='Convert .properties files to YAML format',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s config.properties
  %(prog)s config.properties -o output.yaml
  %(prog)s config.properties --flatten
  %(prog)s *.properties
        """
    )
    
    parser.add_argument(
        'input_files',
        nargs='+',
        type=Path,
        help='Input .properties file(s) to convert'
    )
    
    parser.add_argument(
        '-o', '--output',
        type=Path,
        help='Output YAML file (only valid for single input file)'
    )
    
    parser.add_argument(
        '-f', '--flatten',
        action='store_true',
        help='Keep properties flat instead of creating nested structure'
    )
    
    args = parser.parse_args()
    
    # Validate arguments
    if args.output and len(args.input_files) > 1:
        print("Error: --output can only be used with a single input file", file=sys.stderr)
        sys.exit(1)
    
    # Process each file
    for input_file in args.input_files:
        if not input_file.exists():
            print(f"Error: File not found: {input_file}", file=sys.stderr)
            continue
        
        if not input_file.is_file():
            print(f"Error: Not a file: {input_file}", file=sys.stderr)
            continue
        
        convert_properties_to_yaml(input_file, args.output, args.flatten)


if __name__ == '__main__':
    main()
