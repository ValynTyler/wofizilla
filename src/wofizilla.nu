#!/usr/bin/env nu

def profilesPath [
  type?: string = firefox
] {
  match $type {
    zen => "~/.zen/profiles.ini"
    firefox => "~/.mozilla/firefox/profiles.ini"
    thunderbird => "~/.thunderbird/profiles.ini"
  } | path expand
}

def apps [] { [ zen firefox thunderbird ] }

def main [
  app?: string@apps = firefox,
] {
  let path = profilesPath $app

  if ($path | path exists) {
    let choice = open $path
    | transpose title record
    | where title =~ '^Profile[0-9]+$'
    | each {|profile| $profile.record.Name }
    | to text
    | wofi --show dmenu
    nu -c $'($app) -p "($choice)"'
  } else {
    print "Profile config not found."
    exit 1
  }
}
