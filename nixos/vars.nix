{
  # Central binary cache — server, push hook, and consumers all derive from this.
  cache = {
    host = "linux";
    user = "ibarahime";
    port = 6767;
    publicKey = "linux:50Z8sykXT/bzVBxvIWU2K6H2oPWm21M4SeFxS8NtgZ4=";
  };

  linux = {
    username = "ibarahime";
    hostname = "linux";
    system = "x86_64-linux";
    homePrefix = "/home";
    stateVersion = "25.11";
  };
  thinkpad = {
    username = "violet";
    hostname = "thinkpad";
    system = "x86_64-linux";
    homePrefix = "/home";
    stateVersion = "24.11";
  };
   e14 = {
	username="vi";
	hostname="edgy14yearold";
	system="x86_64-linux";
	homePrefix="/home";
	stateVersion="25.11";
  };
  t420blazeit = {
  	username="vi";
	hostname="t420blazeit";
	system="x86_64-linux";
	homePrefix="/home";
	stateVersion="26.05";
  };
  x201 = {
  	username="vi";
	hostname="x201";
	system="x86_64-linux";
	homePrefix="/home";
	stateVersion="26.05";
 };
  surfaceedged = {
  	username="vi";
	hostname="surfaceedged";
	system="x86_64-linux";
	homePrefix="/home";
	stateVersion="26.05";
 };
  darwin = {
    username = "ibarahime";
    hostname = "homura";
    system = "aarch64-darwin";
    homePrefix = "/Users";
    stateVersion = "26.05";
  };
}
