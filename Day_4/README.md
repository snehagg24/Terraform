## This assignment is follow-up on the previous assignment

· Install an HTTP service and host an index.html file on the server created in the previous assignment.

· Use the file-provisioner to copy the index.html file from local machine.

· Steps to install and configure httpd should be done via remote-exec resource.

· Once the index.html file is hosted on the server, download the file via “HTTP URL” using HTTP Provider (https://www.terraform.io/docs/providers/http/index.html).

· Index.html content should be displayed in Terraform output.

· Whenever the server is destroyed (via ‘terraform destroy’) the index.html and httpd service (including the changed file) should be uninstalled from the remote server.

Note: For Docker assignment you may need to install an SSH service on the container and expose port 22. See https://docs.docker.com/engine/examples/running_ssh_service/ for more information.
