let
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcM3fGjT0HJ2ApA0m/6oyFJV9HBJk/9JzhB3P0IVdOu root@homeserver";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQzXCHZhk/rHUSLI8+E5lNM3O1ZoZWUjyOPZG7Ivb5u kieran@Mac-2.lan";
  work = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKH56JrMAb3Tke2I1Oj1trLEnKwhb4IZDg6eClVQ3NyQ kieran@kieran-work.lan";
  allKeys = [ server laptop work ];
  personal = [ server laptop ];
in
{
  "openrouter-api-key.age".publicKeys = personal;
  "github-token.age".publicKeys = allKeys;
}
