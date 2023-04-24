#![windows_subsystem = "windows"]

use std::env;
use std::process::Command;
use winreg::enums::HKEY_CURRENT_USER;
use winreg::enums::KEY_READ;
use winreg::RegKey;

fn main() {
    let key = RegKey::predef(HKEY_CURRENT_USER)
        .open_subkey_with_flags(
            r"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe",
            KEY_READ,
        )
        .unwrap();
    let value: String = key.get_value("").unwrap();

    let url = env::args().nth(1).unwrap_or(String::new());

    Command::new(value)
        .args(["-private-window", &url])
        .spawn()
        .unwrap();
}
