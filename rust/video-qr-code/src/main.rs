use core::*;

pub fn main() {
    let result = get_qr_codes_from_video("/Users/doitsu2014/Workspace/doitsu-technology/videos/IMG_5576.mov").unwrap();

    // Print the HashMap of Qr Code Values
    result.into_iter().for_each(|x| {
        println!("Browsing qr code: {}", x.0);
        println!("Values: {}", x.1);
    });
}
