# nubis-confluence
-------------------
### Getting started
How to build confluence using a combination of packer + cloudformation + nubis magic, this works with my current setup, so modify path to fit your needs

1. Run the *packer-build.sh* script from the project base directory this builds our AMI based on what we have on projects.json and provisioners.json
```bash
$ ./bin/packer-build.sh
```
2. From the output of *packer-build.sh* you will get an ami id, edit the *nubis/cloudformation/parameters.json* file with the relevant information and place the ami-id where in there
3. Build your stack using the *build.sh* script
```bash
$ ./bin/build.sh confluence
```
4. Update consul
``` bash
export PATH="~/git/nubis-builder/bin:$PATH"
nubis-consul --settings nubis/cloudformation/parameters.json --stack-name
```

### Other commands
* How to check if your stack is done building
```bash
aws cloudformation describe-stack-events --stack-name confluence
```

* How to check your stack
```bash
aws cloudformation describe-stacks --stack-name confluence
```
