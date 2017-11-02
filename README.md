# gitmodules
Maker allows Gnu Make to streamline development of dockerized apps

Always you have some codes to be run as part of deployment procedure. The best way is to abstract this to have the same way to setup your application in the local machine or in the ci or for staging and prod. The only things that is already available for all environments is bash.

If you want to use bash scripts in a transparent way to have same set of commands to get your app setup then you need to factor out things to and manage them centralized to be able to change and maintain them.

So git sub module comes to the picture to include these scripts once needed in the project itself and get it managed, updated as features are gradually are found. The other option is to install it as a shared dependency in the machine but this option is not always possible since outside the repo it might have permission limitations. So we want an external package to be fetched into the main repo with less dependency to other third party packages. So we require git to manage the dependency for the project.

Another assumtion is that the app is a dockerized app being built in CI. If you want to integrate with GitLab CI you need to put the config file in the repo itself. So you need to factor out build scripts from the CI description file to be able to re use them in local machine at least for development. Sohi this is another place you would need to populate environment variables that are missing  to your local machine to be able to run the script.

So you should have a solution to 

1. manage build and deployment scripts in a way to be able to have development production parity
2. Have common functionality factored out in a shared place to be able to use them everywhere
3. Being able to run the tool everywhere even in production or in the CI that you have access to limited set of tools
4. Be able to manage the package and receive upgrades


Maker is a git module uses shell
