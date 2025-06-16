{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    dotnet-sdk_8
    dotnetPackages.Nuget
  ];
}
