#!/usr/bin/env python3

import os
import argparse
import hashlib
import subprocess
from datetime import datetime

def calculate_file_hash(filepath):
    """
    Calculate SHA-256 hash of a file.
    
    :param filepath: Path to the file
    :return: Hex digest of the file's hash
    """
    hasher = hashlib.sha256()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hasher.update(chunk)
    return hasher.hexdigest()

def check_hdfs_file_exists(hdfs_path):
    """
    Check if a file exists in HDFS.
    
    :param hdfs_path: Full HDFS path to the file
    :return: Boolean indicating file existence
    """
    try:
        result = subprocess.run(['hdfs', 'dfs', '-test', '-e', hdfs_path], 
                                capture_output=True, text=True)
        return result.returncode == 0
    except Exception as e:
        print(f"Error checking HDFS file existence: {e}")
        return False

def get_hdfs_file_info(hdfs_path):
    """
    Get file information from HDFS.
    
    :param hdfs_path: Full HDFS path to the file
    :return: Dictionary with file information
    """
    try:
        result = subprocess.run(['hdfs', 'dfs', '-ls', hdfs_path], 
                                capture_output=True, text=True)
        if result.returncode == 0:
            # Parse the output to extract modification time and other details
            parts = result.stdout.strip().split()
            return {
                'exists': True,
                'mod_time': parts[5],
                'size': int(parts[4])
            }
    except Exception as e:
        print(f"Error getting HDFS file info: {e}")
    return {'exists': False}

def upload_to_hdfs(local_path, hdfs_base_dir, force=False):
    """
    Upload file to HDFS with optional force update.
    
    :param local_path: Path to local file
    :param hdfs_base_dir: Base HDFS directory to upload to
    :param force: Force upload even if file exists
    :return: Boolean indicating successful upload
    """
    # Ensure HDFS base directory exists
    subprocess.run(['hdfs', 'dfs', '-mkdir', '-p', hdfs_base_dir], check=True)
    
    # Construct full HDFS path
    filename = os.path.basename(local_path)
    hdfs_path = os.path.join(hdfs_base_dir, filename)
    
    # Get local file information
    local_mod_time = os.path.getmtime(local_path)
    local_hash = calculate_file_hash(local_path)
    
    # Check existing HDFS file
    hdfs_file_info = get_hdfs_file_info(hdfs_path)
    
    # Determine if upload is needed
    if force or not hdfs_file_info['exists']:
        # Force upload or file doesn't exist
        print(f"Uploading {local_path} to {hdfs_path}")
        subprocess.run(['hdfs', 'dfs', '-put', '-f', local_path, hdfs_path], check=True)
        return True
    
    # If not forced, check modification time and hash
    try:
        # Compare local and HDFS file attributes
        local_stat = os.stat(local_path)
        if (local_mod_time > hdfs_file_info.get('mod_time', 0) or 
            local_hash != calculate_file_hash(local_path)):
            print(f"Updating {local_path} in HDFS")
            subprocess.run(['hdfs', 'dfs', '-put', '-f', local_path, hdfs_path], check=True)
            return True
        
        print(f"File {filename} is up to date in HDFS")
        return False
    
    except Exception as e:
        print(f"Error processing file {local_path}: {e}")
        return False

def main():
    # Setup argument parser
    parser = argparse.ArgumentParser(description='Upload files to HDFS with intelligent updates')
    parser.add_argument('local_path', help='Path to local file or directory')
    parser.add_argument('hdfs_base_dir', help='Base HDFS directory to upload to')
    parser.add_argument('--force', action='store_true', 
                        help='Force upload and overwrite existing files')
    
    # Parse arguments
    args = parser.parse_args()
    
    # Handle both file and directory uploads
    if os.path.isfile(args.local_path):
        # Single file upload
        upload_to_hdfs(args.local_path, args.hdfs_base_dir, args.force)
    elif os.path.isdir(args.local_path):
        # Directory upload
        for root, _, files in os.walk(args.local_path):
            for file in files:
                full_local_path = os.path.join(root, file)
                relative_path = os.path.relpath(full_local_path, args.local_path)
                hdfs_full_path = os.path.join(args.hdfs_base_dir, relative_path)
                hdfs_dir = os.path.dirname(hdfs_full_path)
                
                upload_to_hdfs(full_local_path, hdfs_dir, args.force)
    else:
        print(f"Error: {args.local_path} is not a valid file or directory")
        exit(1)

if __name__ == '__main__':
    main()
