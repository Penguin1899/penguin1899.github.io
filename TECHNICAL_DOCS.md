# Technical Documentation: Portfolio Site Architecture

## Overview

This document explains the technical architecture and processes behind the dynamic portfolio website system. The site uses a template-driven approach to separate content from presentation, enabling easy maintenance and automated deployment.

## System Architecture

### 1. Data Layer (YAML Files)

The content is stored in structured YAML files located in the `data/` directory:

```yaml
# Example: personal.yml
name: "Rohith Aithal"
title: "Hi"
subtitle: "I am Rohith."
description: "A passionate software engineer..."
```

**Benefits:**
- Human-readable and editable
- Version control friendly
- Structured data validation
- Easy to maintain without HTML knowledge

### 2. Template Layer (Mako Templates)

The presentation layer uses Mako templating engine (`index.mako`):

```mako
<h1>${personal['name']}</h1>
% for skill in skills['categories']:
  <h3>${skill['name']}</h3>
% endfor
```

**Benefits:**
- Separation of content and presentation
- Dynamic content rendering
- Conditional logic and loops
- Reusable components

### 3. Generation Layer (Python Script)

The `generate_site.py` script orchestrates the build process:

```python
def main():
    data = load_all_data("data")
    render_template("index.mako", "index.html", data)
```

**Process Flow:**
1. Load all YAML files from `data/` directory
2. Parse and validate YAML syntax
3. Pass data to Mako template
4. Render final HTML file
5. Handle errors gracefully

### 4. Styling Layer (Tailwind CSS)

Tailwind CSS provides utility-first styling:

```bash
npx @tailwindcss/cli -i ./src/input.css -o ./dist/output.css
```

**Benefits:**
- Responsive design out of the box
- Consistent design system
- Optimized CSS output
- Development efficiency

## Automation & CI/CD

### GitHub Actions Workflow

The `.github/workflows/ci-cd.yml` file defines the automated pipeline:

#### Validation Steps

1. **YAML Validation**
   ```python
   yaml.safe_load(file_content)  # Validates syntax
   ```

2. **Python Code Quality**
   ```bash
   black --check --diff .        # Formatting check
   flake8 .                      # Linting
   ```

3. **Site Generation Test**
   ```bash
   python generate_site.py       # Test build process
   ```

4. **HTML Validation**
   ```bash
   grep -q "<html" index.html    # Basic structure check
   ```

#### Deployment Process

On successful validation:
1. Build CSS with Tailwind
2. Generate final HTML
3. Deploy to GitHub Pages
4. Exclude source files from deployment

### Quality Assurance

#### YAML Schema Validation

The system validates that YAML files contain expected structure:

```python
required_keys = ["personal", "skills", "experience", "projects", "contact"]
missing_keys = [key for key in required_keys if not data.get(key)]
```

#### Error Handling

Comprehensive error handling for common issues:
- Missing files
- Invalid YAML syntax
- Template rendering errors
- Missing dependencies

## Development Workflow

### Local Development

1. **Content Updates**
   ```bash
   # Edit YAML files
   vim data/personal.yml
   
   # Generate site
   python generate_site.py
   
   # Preview changes
   open index.html
   ```

2. **Style Changes**
   ```bash
   # Start Tailwind watch mode
   npm run build-css -- --watch
   
   # Edit template
   vim index.mako
   
   # Regenerate
   python generate_site.py
   ```

### Production Deployment

Automated via Git workflow:
```bash
git add .
git commit -m "Update portfolio content"
git push origin main  # Triggers automatic deployment
```

## File Structure Deep Dive

### Data Files Structure

```yaml
# skills.yml structure
categories:
  - name: "Programming Languages"
    items:
      - name: "Python"
        icon: "https://example.com/python-icon.svg"

# projects.yml structure
companies:
  - name: "Company Name"
    projects:
      - title: "Project Title"
        period: "2021-2024"
        description: "Project description"
        technologies:
          - name: "Python"
            color: "bg-green-100 text-green-700"
```

### Template Structure

The Mako template includes:
- Navigation generation from data
- Dynamic section rendering
- Conditional content display
- Loop constructs for repeated elements

### Configuration Files

- `pyproject.toml`: Black formatter configuration
- `tailwind.config.js`: Tailwind CSS settings
- `requirements.txt`: Python dependencies
- `package.json`: Node.js dependencies and scripts

## Performance Considerations

### Build Performance

- YAML parsing is fast for small to medium datasets
- Template rendering is efficient for single-page sites
- CSS generation only includes used classes (Tailwind purging)

### Runtime Performance

- Static HTML output (no server-side processing needed)
- Optimized CSS bundle
- CDN-friendly assets (external icon URLs)

## Security Considerations

### Template Security

- Using `safe_load()` for YAML parsing (prevents code injection)
- Mako's automatic HTML escaping (prevents XSS)
- No user input processing in templates

### CI/CD Security

- GitHub token for deployment (secure)
- No sensitive data in public repository
- Dependencies pinned to specific versions

## Maintenance & Monitoring

### Error Monitoring

GitHub Actions provides:
- Build status notifications
- Detailed error logs
- Failed build prevention of deployment

### Content Validation

Automated checks ensure:
- Valid YAML syntax
- Required data fields present
- Template rendering success
- HTML structure validity

## Future Enhancements

Potential improvements:
1. **Schema Validation**: JSON Schema for YAML files
2. **Image Optimization**: Automated image processing
3. **SEO Enhancement**: Meta tags generation from data
4. **Analytics Integration**: Automated tracking code injection
5. **Multi-language Support**: Internationalization framework

## Troubleshooting

### Common Issues

1. **YAML Syntax Errors**
   ```
   Error: Invalid YAML in data/skills.yml: found character '\t'
   ```
   Solution: Use spaces instead of tabs for indentation

2. **Template Rendering Errors**
   ```
   NameError: name 'personal' is not defined
   ```
   Solution: Ensure all required YAML files exist and contain data

3. **CSS Not Loading**
   ```
   Stylesheet not found: ./dist/output.css
   ```
   Solution: Run `npm run build-css` to generate CSS

### Debug Mode

Enable verbose output in `generate_site.py`:
```python
# Add detailed logging
import logging
logging.basicConfig(level=logging.DEBUG)
```

This technical documentation provides a comprehensive understanding of the system architecture and processes, enabling effective maintenance and enhancement of the portfolio website.
