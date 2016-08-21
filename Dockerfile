FROM phusion/baseimage:0.9.19

# Install Dependencies
RUN apt-get update \
    && apt-get install -y curl gettext libunwind8 libcurl4-openssl-dev libicu-dev libssl-dev

# Install .NET Core
RUN mkdir -p /opt/dotnet \
    && curl -Lsfo /opt/dotnet/dotnet-install.sh https://raw.githubusercontent.com/dotnet/cli/rel/1.0.0/scripts/obtain/dotnet-install.sh \
    && bash /opt/dotnet/dotnet-install.sh --version 1.0.0-preview3-003223 --install-dir /opt/dotnet \
    && ln -s /opt/dotnet/dotnet /usr/local/bin


# Display info installed components
RUN dotnet --info

# Prime dotnet
RUN mkdir hwapp \
    && cd hwapp \
    && dotnet new \
    && dotnet restore \
    && dotnet run \
    && cd .. \
    && rm -rf hwapp

# Add Cake
ADD caketools /opt/caketools

# Display Cake Version
RUN cd /opt/caketools/Cake && dotnet Cake.dll --version

# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*