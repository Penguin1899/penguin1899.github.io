#!/usr/bin/env python3
"""
Portfolio Site Generator

This script generates an HTML file from a Mako template and YAML data files.
It loads data from the 'data/' directory and renders the 'index.mako' template
to create the final 'index.html' file.

Usage:
    python generate_site.py

Dependencies:
    - mako
    - pyyaml
"""

import os
import yaml
from mako.template import Template
from mako.exceptions import RichTraceback
from pathlib import Path


def load_yaml_file(file_path):
    """
    Load and parse a YAML file.

    Args:
        file_path (str): Path to the YAML file

    Returns:
        dict: Parsed YAML content

    Raises:
        FileNotFoundError: If the file doesn't exist
        yaml.YAMLError: If the YAML is invalid
    """
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            return yaml.safe_load(file)
    except FileNotFoundError:
        print(f"Error: Could not find file {file_path}")
        raise
    except yaml.YAMLError as e:
        print(f"Error: Invalid YAML in {file_path}: {e}")
        raise


def load_all_data(data_dir="data"):
    """
    Load all YAML data files from the data directory.

    Args:
        data_dir (str): Directory containing YAML data files

    Returns:
        dict: Dictionary containing all loaded data
    """
    data = {}
    data_files = {
        "personal": "personal.yml",
        "skills": "skills.yml",
        "experience": "experience.yml",
        "projects": "projects.yml",
        "contact": "contact.yml",
    }

    for key, filename in data_files.items():
        file_path = os.path.join(data_dir, filename)
        if os.path.exists(file_path):
            data[key] = load_yaml_file(file_path)
            print(f"Loaded {filename}")
        else:
            print(f"Warning: {filename} not found, skipping...")
            data[key] = {}

    return data


def render_template(template_file, output_file, data):
    """
    Render a Mako template with the provided data.

    Args:
        template_file (str): Path to the Mako template file
        output_file (str): Path for the output HTML file
        data (dict): Data to pass to the template

    Raises:
        Exception: If template rendering fails
    """
    try:
        # Load the template
        with open(template_file, "r", encoding="utf-8") as file:
            template_content = file.read()

        template = Template(template_content)

        # Render the template with data
        rendered_html = template.render(**data)

        # Write the output
        with open(output_file, "w", encoding="utf-8") as file:
            file.write(rendered_html)

        print(f"Successfully generated {output_file}")

    except Exception as e:
        print(f"Error rendering template: {e}")
        # Print detailed traceback for Mako template errors
        if hasattr(e, "source"):
            traceback = RichTraceback()
            for filename, lineno, function, line in traceback.traceback:
                print(f"File {filename}, line {lineno}, in {function}")
                print(f"  {line}")
            print(f"{traceback.error.__class__.__name__}: {traceback.error}")
        raise


def validate_output_directory():
    """
    Ensure the output directory exists for CSS files.
    """
    dist_dir = "dist"
    if not os.path.exists(dist_dir):
        print(
            f"Warning: {dist_dir} directory not found. Make sure to run Tailwind CSS build."
        )


def main():
    """
    Main function to generate the portfolio site.
    """
    print("Portfolio Site Generator")
    print("=" * 40)

    # Define file paths
    template_file = "index.mako"
    output_file = "index.html"
    data_dir = "data"

    # Check if template file exists
    if not os.path.exists(template_file):
        print(f"Error: Template file {template_file} not found!")
        return 1

    # Check if data directory exists
    if not os.path.exists(data_dir):
        print(f"Error: Data directory {data_dir} not found!")
        return 1

    try:
        # Load all data files
        print("\nLoading data files...")
        data = load_all_data(data_dir)

        # Validate that we have all required data
        required_keys = ["personal", "skills", "experience", "projects", "contact"]
        missing_keys = [key for key in required_keys if not data.get(key)]

        if missing_keys:
            print(f"Warning: Missing data for: {', '.join(missing_keys)}")

        # Render the template
        print(f"\nRendering template...")
        render_template(template_file, output_file, data)

        # Check output directory
        validate_output_directory()

        print(f"\n✅ Site generation completed successfully!")
        print(f"📄 Output: {output_file}")
        print(f"🎨 Don't forget to build your CSS with: npm run build-css")

        return 0

    except Exception as e:
        print(f"\n❌ Site generation failed: {e}")
        return 1


if __name__ == "__main__":
    exit(main())
