#! /usr/bin/env python3
import locale
import sys
import os
import yaml
import yamlordereddictloader
from dialog import Dialog
import urllib.request
from subprocess import Popen, PIPE


locale.setlocale(locale.LC_ALL, '')

config_file = './mikado.conf'

d = Dialog(dialog="dialog", autowidgetsize=True)
d.set_background_title("Mikado")

with open("./scripts/install.yaml", 'r') as stream:
    try:
        yamlconfig = yaml.load(stream, Loader=yamlordereddictloader.Loader)
    except yaml.YAMLError as exc:
        print(exc)

dialogs = yamlconfig.get('dialogs')


def d_optional():
    """
    Component selector
    """
    return d.checklist(
      dialogs.get('optional').get('msg'),
      choices=[(a, "", False) for a in dialogs.get('optional').get('components')],
      title=dialogs.get('optional').get('title')
    )


def d_inputs(fields):
    """
    Input dialog generator
    """
    output = dict()
    for field in fields:
        output[field] = dict()
        for fd in dialogs.get(field):
            def_value = dialogs.get(field).get(fd).get('default', '')

            # set default CIDR helper
            if def_value == '@@@cidr@@@':
                def_value = "{}/32".format(
                  urllib.request.urlopen(
                    'http://ifconfig.io/ip'
                    ).read().decode('ascii').strip()
                )

            c, output[field][fd] = d.inputbox(
              dialogs.get(field).get(fd).get('msg'),
              init=def_value
            )
            if c != d.OK:
                return False

    return output


def d_error(msg):
    """
    Error dialog
    """
    d.msgbox(dialogs.get('errors').get(msg))
    sys.exit(1)

def d_info(dialog):
    """
    Info dialog
    """
    d.msgbox(dialogs.get(dialog))

def write_config(config):
    """
    config file handler
    """
    output = ""
    c = [c for c in config.values()]
    for service in c:
        for k, v in service.items():
            output += "export {}=\"{}\"\n".format(k, v)

    with open(config_file, 'w') as out:
        out.write(output + '\n')


def execute(cmd):
    """
    shell executor
    """
    os.environ["CONTINUE"] = "y"

    cmd = cmd.split(' ')
    with Popen(cmd, stdout=PIPE, bufsize=1, universal_newlines=True) as p:
        for line in p.stdout:
            print(line, end='')


def create_tf(domain, fastly=None, statuscake=None):
    """
    Create the initial terraform config for the domain
    """
    if fastly is None and statuscake is None:
        file = './examples/basic.tf'
    if fastly is None and statuscake:
        file = './examples/basic-with-statuscake.tf'
    if fastly and statuscake is None:
        file = './examples/basic-with-fastly.tf'
    else:
        file = './examples/basic-with-fastly-statuscake.tf'

    output = ""
    with open(file, 'r') as stream:
        data = stream.read()
        cnf = data.replace('###DOMAIN###', domain)

    with open('terraform/{}.tf'.format(domain), 'w') as out:
        out.write(cnf + '\n')


def install():
    # Display welcome screen
    d_info('welcome')

    c, optional_fileds = d_optional()
    # get required data and validate it
    base_data = d_inputs(['Mikado'])
    if len([a for a in base_data.get('Mikado').values() if not a]):
        return d_error('missing_data')
        pass

    optional_data = d_inputs(optional_fileds)

    config = base_data.copy()
    config.update(optional_data)

    write_config(config)

    d_info('tfbase')
    # build base infra
    execute('make apply')

    d_info('amibuild')
    execute('make build-ami')
    execute('make deploy-ami')

    d_info('tfmikado')
    create_tf(
        domain=config.get('Mikado').get('domain'),
        fastly=len(list(filter(None, config.get('Datadog', {}).values()))),
        statuscake=len(list(filter(None, config.get('Datadog', {}).values())))
    )

    execute('make apply')

    d_info('success')


def main():
    install()


if __name__ == '__main__':
    main()
