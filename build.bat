rustup.exe target add i686-pc-windows-msvc
cargo.exe build --release --target=i686-pc-windows-msvc
cargo.exe build --release --target=x86_64-pc-windows-msvc
"C:\Program Files (x86)\Inno Setup 6\Compil32.exe" /cc Privatefox.iss
