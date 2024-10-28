# Use the latest Debian image
FROM debian:latest

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server

# Create the SSH directory and set up the SSH key
RUN mkdir /var/run/sshd

# Set the root password (you can change this to a more secure password)
RUN echo 'root:rootpassword' | chpasswd

# Allow root login via SSH
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose the SSH port
#EXPOSE 22

# Add the current directory to the container
ADD . /rtl8821cu-dkms

# Set the working directory
WORKDIR /rtl8821cu-dkms

# Install the required packages
RUN debian/install_pkg_build_deps.sh

# Start the SSH service
CMD ["/usr/sbin/sshd", "-D"]