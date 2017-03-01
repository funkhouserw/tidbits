# DS705 R-server sandbox

-------

*Objective:* Set up a reliable server to which knitted ds705 documents can be
published using the built-in rstudio publish feature. 

*Current server config:* Hosted on EC2, with S3 bucket and access available.
server has rstudioserver and jupyter notebook server running on it.  That is
all. 

-------

## General Information

### Server located at: http://uwds.horse.bike
  - SSH access available
  - Access to ports 8787 and 8888, and 80 open

### R-Studio-Server
  - accessed at http://uwds.horse.bike/8787
  - u: jeff p: m3t4l
  - Note: no ssl 

### Jupyter notebook server
  - accessed at https://uwds.horse.bike/8888
  - p: m3t4l
  - Note: SSL required.  Proceed despite warning of bad ssl cert
  - Note: both python2 and python3 kernels are installed. yay. 


### S3 Information: 
  - Bucket labeled s3.uwgb.705
  - Currently an IAM user has full access to it (provided below)
      - non-read access is managed by this user's user-group in IAM
  - Any uploaded document is currently publicly available 
      - this access is managed by the bucket policy in s3
  - Access credentials at bottom of this document. 

### SSH access
  - change permissions of file to 400 (`$sudo chmod 400 pemfile.pem)
  - `$ssh-add ~/path/to/pemfile.pem`
  - `$ssh ubuntu@uwds.horse.bike`
  - Note: currently only ubuntu user has ssh access. there is also a 'jeff' user to satisfy r-studio-server requirements 
      - This means there is a /home/jeff directory where R-studio defaults to. 

------

## Credentials 

#### S3 IAM user access

  - u: uwgb-r-server-user
  - access key: <Ask wilson for this information> 
  - secret key: <Ask wilson for this information>


#### Private pem key. Save this as `uwgbserver.pem`
  ```
 -----BEGIN RSA PRIVATE KEY-----
 <ask wilson for this information>
-----END RSA PRIVATE KEY-----

  ```
