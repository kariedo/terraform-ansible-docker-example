
### What is this ?
Quick example how to setup Docker droplet at DigitalOcean with terraform and ansible.

More details in the [blog post](https://stas.starikevich.com/posts/wiring-terraform-and-ansible/).

### How to start

Clone the repo:

```sh
  $ git clone https://github.com/kariedo/terraform-ansible-docker-example.git
```

Adjust the `terraform.tfvars` with SSH fingerprint and your external IPv4 address

Export DigitalOcean token:

```sh
  $ export TF_VAR_do_token="veryLongStringWithToken"
```

Execute:
```sh
  $ terraform init
  $ terraform apply
```

### Author

**Stas Starikevich**

* [github.com/kariedo](https://github.com/kariedo/)

### License

Copyright © 2020, [kariedo](https://github.com/kariedo).
Released under the [MIT License](LICENSE).
