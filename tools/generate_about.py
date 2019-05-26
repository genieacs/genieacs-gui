#!/usr/bin/python3

from sys import argv
from json import load
from subprocess import Popen, PIPE
from re import search
from urllib import request

# global
genieacs_path = "../../genieacs"
genieacs_string = ""
genieacs_gui_string = ""
licenses_string = ""
licenses = set(['AGPL-3.0', 'MIT'])

# read path to genieacs folder if present
if len(argv) > 1:
    genieacs_path = argv[1]
print("Using %s as path to genieacs.\n" % (genieacs_path))

# get genieacs dependencies from package.json
try:
    packagefile = open(genieacs_path + "/package.json", 'r')
except IOError:
    print("""Could not open genieacs package.json.
Make sure you are in the tools directory.
Aborting.""")
    exit(1)

genieacs = load(packagefile)
packages = []
# merge all kind of dependencies, if present
try:
    packages.extend(genieacs['dependencies'])
    packages.extend(genieacs['devDependencies'])
    packages.extend(genieacs['optionalDependencies'])
except KeyError:
    pass
packagefile.close()

# find out license for each dependency
for package in packages:
    ps = Popen("npm view " + package + " license",
               shell=True, stdout=PIPE, universal_newlines=True)
    for line in ps.stdout:
        license = line[:-1]
        break
    # create table entries for dependencies and add licenses to the set
    genieacs_string += "  <tr>\n    <td>" + package + "</td>\n    <td>" + \
                       license + "</td>\n  </tr>\n"
    licenses.add(license)

# get genieacs-gui dependencies from Gemfile
try:
    gemfile = open("../Gemfile", 'r')
except IOError:
    print("""Could not open genieacs-gui Gemfile.
Make sure you are in the tools directory.
Aborting.""")
    exit(1)

# check all lines for dependencies
for line in gemfile:
    match = search(r'^\s*gem\s+[\'\"]([\w-]+)[\'\"]', line)
    if match is not None:
        package = match.group(1).strip()
        if package == "tzinfo-data":
            package = "tzinfo"
        if package == "json":
            package = "multi_json"
        # find out license for each dependency by using local gem files
        ps = Popen("gem specification ../vendor/bundle/ruby/*/cache/" +
                   package + "-[0-9]* licenses", shell=True,
                   stdout=PIPE, universal_newlines=True)
        # wait for gem call to terminate
        ps.wait()
        if ps.returncode == 0:
            for line in ps.stdout:
                if line.startswith("- "):
                    license = line.split(" ")[1][:-1]
                    if license == "BSD-3":
                        license = "BSD-3-Clause"
                    if license == "BSD":
                        license = "BSD-2-Clause"
                    break
            # create table entries for dependencies and add licenses to the set
            genieacs_gui_string += "  <tr>\n    <td>" + package + \
                                   "</td>\n    <td>" + license + \
                                   "</td>\n  </tr>\n"
            licenses.add(license)
gemfile.close()

# fetch the licenses texts from the spdx project on github
for license in sorted(licenses):
    with request.urlopen("https://raw.githubusercontent.com/" +
                         "spdx/license-list-data/master/text/" +
                         license + ".txt") as license_page:
        license_text = license_page.read().decode('utf-8')
    license_page.close()
    licenses_string += "<p><br><b>" + license + \
        "</b><br><br></p>\n  <pre style='" + \
        "white-space: pre-wrap; outline:1px solid #aaaaaa; padding: 5px; " + \
        "background-color: #f5f5f5;'><code>" \
        + license_text + "</code></pre><br>\n\n"

# open template file and read content into a string variable
try:
    template = open("../app/views/about/index.base.html.erb", 'r')
except IOError:
    print("""Could not open template file.
Make sure you are in the tools directory.
Aborting.""")
    exit(1)

inputstring = template.read()
template.close()

# open html file and write content
try:
    html = open("../app/views/about/index.html.erb", 'w+')
except IOError:
    print("""Could not open html file.
Make sure you are in the tools directory.
Aborting.""")
    exit(1)

html.write(inputstring %
           (genieacs_string, genieacs_gui_string, licenses_string))
html.flush()
html.close()
