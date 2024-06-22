# Notes on the VSCode settings.


### "yaml.customTags"
We use the `redhat.vscode-yaml` extension to format and validate YAML files.

This extension does not recognize CloudFormation [custom tags](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html).

To resolve this, we add these tags manually in the settings config file. As of 6/21/2024 this is still necessary. 

Additional information can be found on this ongoing GitHub issues -> [Unresolved tag: !Ref in CloudFormation Template](https://github.com/redhat-developer/vscode-yaml/issues/669)

