import oyaml as yaml

def prompt_until_valid(prompt, valid_values=None, validate=True):
    while True:
        value = input(prompt)
        if not validate or (value and (valid_values is None or value in valid_values)):
            return value

def main():
    # Prompt for template details
    template = {
        'id': prompt_until_valid('Template ID: '),
        'info': {
            'name': prompt_until_valid('Template Name: '),
            'description': prompt_until_valid('Template Description: '),
            'reference': [prompt_until_valid('Template Reference: ')],
            'author': prompt_until_valid('Template Author: '),
            'severity': prompt_until_valid('Template Severity: ', ['info', 'low', 'medium', 'high', 'critical']),
            'tags': prompt_until_valid('Template Tags: '),
        },
    }

    # Ask for unsafe option
    unsafe = prompt_until_valid('Unsafe option (yes/no): ', ['yes', 'no']) == 'yes'

    # Select template type
    template_type = prompt_until_valid('Template type (HTTP/Network/File/DNS): ', ['HTTP', 'Network', 'File', 'DNS'])

    try:
        if template_type == 'HTTP':
            # Add HTTP requests
            template['requests'] = []
            while True:
                request = {
                    'method': prompt_until_valid('Template Method (GET/POST): ', ['GET', 'POST'], not unsafe),
                    'path': [],
                    'matchers-condition': prompt_until_valid('Template Matchers Condition (and/or): ', ['and', 'or'], not unsafe),
                    'matchers': [],
                }

                # Add matchers
                while True:
                    matcher = {
                        'type': prompt_until_valid('Template Matchers Type (status/regex/word): ', ['status', 'regex', 'word'], not unsafe),
                        'part': prompt_until_valid('Template Matchers Part (body/header): ', ['body', 'header'], not unsafe),
                    }
                    matcher[matcher['type'] + 's'] = [prompt_until_valid(f"Template {matcher['type']} Matchers: ")]
                    request['matchers'].append(matcher)

                    if prompt_until_valid('Add another matcher (yes/no): ', ['yes', 'no']) != 'yes':
                        break

                template['requests'].append(request)

                if prompt_until_valid('Add another request (yes/no): ', ['yes', 'no']) != 'yes':
                    break

        elif template_type == 'Network':
            # Add Network requests
            template['network'] = []
            while True:
                request = {
                    'data': prompt_until_valid('Data: '),
                    'read-size': prompt_until_valid('Read Size: '),
                    'matchers': [],
                }

                # Add matchers
                while True:
                    matcher = {
                        'type': prompt_until_valid('Template Matchers Type (word/regex/binary/size): ', ['word', 'regex', 'binary', 'size'], not unsafe),
                    }
                    matcher[matcher['type'] + 's'] = [prompt_until_valid(f"Template {matcher['type']} Matchers: ")]
                    request['matchers'].append(matcher)

                    if prompt_until_valid('Add another matcher (yes/no): ', ['yes', 'no']) != 'yes':
                        break

                template['network'].append(request)

                if prompt_until_valid('Add another request (yes/no): ', ['yes', 'no']) != 'yes':
                    break

        elif template_type == 'File':
            # Add File requests
            template['file'] = []
            while True:
                request = {
                    'extension': prompt_until_valid('File Extension: '),
                    'words': prompt_until_valid('Words: '),
                    'matchers': [],
                }

                # Add matchers
                while True:
                    matcher = {
                        'type': prompt_until_valid('Template Matchers Type (word/regex/binary/size): ', ['word', 'regex', 'binary', 'size'], not unsafe),
                    }
                    matcher[matcher['type'] + 's'] = [prompt_until_valid(f"Template {matcher['type']} Matchers: ")]
                    request['matchers'].append(matcher)

                    if prompt_until_valid('Add another matcher (yes/no): ', ['yes', 'no']) != 'yes':
                        break

                template['file'].append(request)

                if prompt_until_valid('Add another request (yes/no): ', ['yes', 'no']) != 'yes':
                    break

        elif template_type == 'DNS':
            # Add DNS requests
            template['dns'] = []
            while True:
                request = {
                    'name': prompt_until_valid('Name: '),
                    'type': prompt_until_valid('Type: '),
                    'class': prompt_until_valid('Class: '),
                    'recursion': prompt_until_valid('Recursion Desired (yes/no): ', ['yes', 'no']),
                    'retries': prompt_until_valid('Retries: '),
                    'matchers': [],
                }

                # Add matchers
                while True:
                    matcher = {
                        'type': prompt_until_valid('Template Matchers Type (word/regex): ', ['word', 'regex'], not unsafe),
                    }
                    matcher[matcher['type'] + 's'] = [prompt_until_valid(f"Template {matcher['type']} Matchers: ")]
                    request['matchers'].append(matcher)

                    if prompt_until_valid('Add another matcher (yes/no): ', ['yes', 'no']) != 'yes':
                        break

                template['dns'].append(request)

                if prompt_until_valid('Add another request (yes/no): ', ['yes', 'no']) != 'yes':
                    break

    except Exception as e:
        print(f"An error occurred: {e}")

    # Output template
    print(yaml.dump(template))

if __name__ == "__main__":
    main()
