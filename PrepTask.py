import configparser
import argparse
import sys
import os
import shutil

parser = argparse.ArgumentParser()

parser.add_argument('--config', type=str, default='dosbox-0.74-3.conf') # Dosbox config file
parser.add_argument('--dir', type=str, default='TaskExample') # Task directory

# Defines if adding build command to autoexec section and name of executable file
parser.add_argument('--build', type=str, required=False) 
parser.add_argument('--add-masm', action='store_true', default=False) # Adding masm compiler to dir
parser.add_argument('--add-cv', action='store_true', default=False) # Adding cv debugger to dir
parser.add_argument('-f', '--force', action='store_true', default=False) # Force to create directory if it doesn't exist
parser.add_argument('-v', '--verbose', action='store_true', default=False) # Verbose mode
args = parser.parse_args(sys.argv[1:])

# Parsing arguments
config = args.config
dir = args.dir
force = args.force
add_masm = args.add_masm
add_cv = args.add_cv
verbose = args.verbose

build = False
if args.build != None:
    buildFname = args.build
    build = True

# Checking if MASM files exist
if add_masm:
    if not os.path.exists('MASM'):
        raise argparse.ArgumentError(f"MASM files not found")

# Checking if CV debugger files exist
if add_cv:
    if not os.path.exists('CV'):
        raise argparse.ArgumentError(f"CV files not found")

# Trying to open and read config file
cp = configparser.ConfigParser(allow_no_value=True) # No value for writing commands in autoexec section
cp.optionxform = str # needed to preserve case in strings

if verbose: print(f"Reading config file {config}...")
try:
    cp.read(config)
except configparser.Error as e:
    if verbose: print(e)
    sys.exit(1)
except FileNotFoundError as e:
    if verbose: print(f"Config file not found! {config}")
    sys.exit(1)
if verbose: print("Done!")

# Checking if directory exists
if verbose: print(f"Checking directory '{dir}'...")
if not os.path.exists(dir):
    if verbose: print(f"'{dir}' Not found!")
    if force: # if force create directory
        if verbose: print(f"Creating directory '{dir}'...")
        os.mkdir(dir)
    else:
        sys.exit(1)
if verbose: print(f"Directory '{dir}' exists!")

# Creating autoexec commands
autoexecCommands = [
    f"mount c {os.path.abspath(dir)}",
    f"C:",
]

if build: # if build flag adding build command to autoexec
    autoexecCommands.append(f"ML.EXE *.ASM /Fe {buildFname}")

# Adding commands to autoexec section
cp['autoexec'] = {c: None for c in autoexecCommands}


if verbose:
    print("Autoexec commands:")
    for c in autoexecCommands:
        print(c)

# Writing config with autoexec commands
if verbose: print(f"Writing config file {config}...")
try:
    cp.write(open(config, 'w'))
except configparser.Error as e:
    if verbose: print(e)
    sys.exit(1)
if verbose: print("Done!")

# Copying MASM compiler files to directory
if add_masm:
    if verbose: print("Copying MASM files...")
    for f in os.listdir('MASM'):
        if verbose: print("Copying file: " + f)
        shutil.copy2(os.path.join('MASM', f), dir)
    if verbose: print("Done!")

# Copying CV debugger files to directory
if add_cv:
    if verbose: print("Copying MASM files...")
    for f in os.listdir('CV'):
        if verbose: print("Copying file: " + f)
        shutil.copy2(os.path.join('CV', f), dir)
    if verbose: print("Done!")

if verbose: print(f"Directory '{dir}' ready!")