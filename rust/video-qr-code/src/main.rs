use opencv::{highgui, videoio};
fn main() {
    println!("Hello, world!");
    let mut cam = videoio::VideoCapture::from_file("./file/file-1.mp4", videoio::CAP_ANY);
    highgui::named_window("window", highgui::WINDOW_FULLSCREEN)?;
    let mut frame = Mat::default();
    
    loop {
        cam.read(&mut frame)?;
        highgui::imshow("window", &frame)?;
        let key = highgui::wait_key(1)?;
        if key == 113 {
            break;
        }
    }

    Ok(())
}
