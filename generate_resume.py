#!/usr/bin/env python3
"""
Resume Generator

This script generates a PDF resume from YAML data files using LaTeX templates.
It uses the same data structure as the website generator but formats it for
a professional resume layout.

Usage:
    python generate_resume.py

Dependencies:
    - mako
    - pyyaml
    - subprocess (for pdflatex)
"""

import os
import yaml
import subprocess
import tempfile
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


def check_latex_installation():
    """
    Check if LaTeX (pdflatex) is installed and available.

    Returns:
        bool: True if LaTeX is available, False otherwise
    """
    try:
        result = subprocess.run(
            ["pdflatex", "--version"], capture_output=True, text=True, timeout=10
        )
        return result.returncode == 0
    except (subprocess.TimeoutExpired, FileNotFoundError):
        return False


def render_latex_template(template_file, output_file, data):
    """
    Render a LaTeX template with the provided data and compile to PDF.

    Args:
        template_file (str): Path to the LaTeX Mako template file
        output_file (str): Path for the output PDF file
        data (dict): Data to pass to the template

    Returns:
        bool: True if successful, False otherwise
    """
    try:
        # Load the template
        with open(template_file, "r", encoding="utf-8") as file:
            template_content = file.read()

        template = Template(template_content)

        # Render the template with data
        rendered_latex = template.render(**data)

        # Create temporary directory for LaTeX compilation
        with tempfile.TemporaryDirectory() as temp_dir:
            tex_file = os.path.join(temp_dir, "resume.tex")

            # Write LaTeX source
            with open(tex_file, "w", encoding="utf-8") as file:
                file.write(rendered_latex)

            print(f"Generated LaTeX source: {tex_file}")

            # Compile LaTeX to PDF
            print("Compiling LaTeX to PDF...")
            result = subprocess.run(
                [
                    "pdflatex",
                    "-interaction=nonstopmode",
                    "-output-directory",
                    temp_dir,
                    tex_file,
                ],
                capture_output=True,
                text=True,
                timeout=30,
            )

            if result.returncode != 0:
                # Check if PDF was created despite errors (LaTeX often succeeds with warnings)
                pdf_source = os.path.join(temp_dir, "resume.pdf")
                if os.path.exists(pdf_source):
                    print("PDF compiled with some LaTeX warnings (this is normal)")
                    import shutil

                    shutil.copy2(pdf_source, output_file)
                    print(f"Successfully generated {output_file}")

                    # Save detailed log for debugging if needed
                    log_file = output_file.replace(".pdf", ".log")
                    with open(log_file, "w") as f:
                        f.write("LaTeX Compilation Log\n")
                        f.write("=" * 40 + "\n")
                        f.write("STDOUT:\n")
                        f.write(result.stdout)
                        f.write("\n\nSTDERR:\n")
                        f.write(result.stderr)
                    print(f"📋 Detailed log saved to: {log_file}")
                    return True
                else:
                    print("❌ LaTeX compilation failed - no PDF generated!")
                    print("Error details:")
                    print(result.stdout[-500:])  # Show last 500 chars only
                    print(result.stderr[-500:])
                    return False

            # Move PDF to final location
            pdf_source = os.path.join(temp_dir, "resume.pdf")
            if os.path.exists(pdf_source):
                import shutil

                shutil.copy2(pdf_source, output_file)
                print(f"Successfully generated {output_file}")
                return True
            else:
                print("PDF file was not generated!")
                return False

    except Exception as e:
        print(f"Error rendering template: {e}")
        # Print detailed traceback for Mako template errors
        if hasattr(e, "source"):
            traceback = RichTraceback()
            for filename, lineno, function, line in traceback.traceback:
                print(f"File {filename}, line {lineno}, in {function}")
                print(f"  {line}")
            print(f"{traceback.error.__class__.__name__}: {traceback.error}")
        return False


def install_latex_packages():
    """
    Attempt to install required LaTeX packages if they're missing.
    This is a basic implementation - users may need to install packages manually.
    """
    print("If PDF generation fails, you may need to install LaTeX packages:")
    print("  - fontawesome5")
    print("  - titlesec")
    print("  - enumitem")
    print("  - hyperref")
    print("  - xcolor")
    print("")
    print(
        "On Ubuntu/Debian: sudo apt-get install texlive-latex-extra texlive-fonts-extra"
    )
    print("On macOS with MacTeX: Should be included")
    print("On Windows with MiKTeX: Should auto-install packages")


def main():
    """
    Main function to generate the resume PDF.
    """
    print("Resume PDF Generator")
    print("=" * 40)

    # Define file paths
    template_file = "templates/resume.tex.mako"
    output_file = "resume.pdf"
    data_dir = "data"

    # Check if LaTeX is installed
    if not check_latex_installation():
        print("❌ LaTeX (pdflatex) is not installed or not found in PATH!")
        print("")
        print("Please install LaTeX:")
        print("  - macOS: Install MacTeX from https://www.tug.org/mactex/")
        print(
            "  - Ubuntu/Debian: sudo apt-get install texlive-latex-base texlive-latex-extra"
        )
        print("  - Windows: Install MiKTeX from https://miktex.org/")
        return 1

    print("✅ LaTeX installation found")

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

        # Render the template and generate PDF
        print(f"\nGenerating PDF resume...")
        success = render_latex_template(template_file, output_file, data)

        if success:
            print(f"\n✅ Resume generation completed successfully!")
            print(f"📄 Output: {output_file}")

            # Get file size for user feedback
            if os.path.exists(output_file):
                file_size = os.path.getsize(output_file)
                print(f"📊 File size: {file_size:,} bytes")
        else:
            print(f"\n❌ Resume generation failed!")
            install_latex_packages()
            return 1

        return 0

    except Exception as e:
        print(f"\n❌ Resume generation failed: {e}")
        return 1


if __name__ == "__main__":
    exit(main())
