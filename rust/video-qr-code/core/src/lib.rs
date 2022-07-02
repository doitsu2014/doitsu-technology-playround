use opencv::{core, highgui, imgproc, objdetect, prelude::*, types, videoio, Result};
use std::{
    collections::{hash_map::DefaultHasher, HashMap},
    hash::{Hash, Hasher},
};

struct Configuration {
    is_debug: bool,
    speed_up: f64,
}

pub fn get_qr_codes_from_video(video_file_path: &str) -> Result<HashMap<u64, String>> {
    let configuration = Configuration { is_debug: false, speed_up: 0.25 };
    let mut qr_detector = objdetect::QRCodeDetector::default()?;
    let mut res = types::VectorOfPoint::new();
    // let mut capture = videoio::VideoCapture::from_file(video_file_path, videoio::CAP_PROP_FRAME_COUNT)?;


    println!("loading video path: {}", video_file_path);
    let mut camera = videoio::VideoCapture::from_file(video_file_path, videoio::CAP_ANY)?;
    let frames = camera.get(videoio::CAP_PROP_FRAME_COUNT)?;
    let fps = camera.get(videoio::CAP_PROP_FPS)?;
    println!("fps: {}", fps);
    let duration = frames/fps;
    println!("Duration (s): {}", duration);
    let new_fps= fps + (fps * 0.25);
    let result_setting_new_fps = camera.set(videoio::CAP_PROP_FPS, new_fps)?;
    println!("Setting new fps result: {}", result_setting_new_fps);

    let mut img = Mat::default();
    let mut recqr = Mat::default();
    let mut qr_codes: HashMap<u64, String> = HashMap::new();

    loop {
        let camera_read_result = camera.read(&mut img)?;
        if camera_read_result == false {
            // let err = camera_read_result.unwrap_err().message;
            println!("End of video");
            break;
        }
        let ret = qr_detector.detect_and_decode(&img, &mut res, &mut recqr)?;
        let s = String::from_utf8_lossy(&ret);
        if !s.is_empty() {
            let calculated_hash = calculate_hash(&s.to_string());
            if !qr_codes.contains_key(&calculated_hash) {
                println!("find a qr code {}", s);
                qr_codes.insert(calculated_hash, s.to_string());
            }
        }

        if configuration.is_debug {
            highgui::named_window("QR Code", highgui::WINDOW_NORMAL)?;
            if recqr.size()?.width > 0 {
                highgui::imshow("QR Code", &recqr)?;
            }
            if res.len() > 0 {
                imgproc::polylines(
                    &mut img,
                    &res,
                    true,
                    core::Scalar::new(0f64, 255f64, 0f64, 0f64),
                    1,
                    1,
                    0,
                )?;
            }
            highgui::imshow("Frame", &img)?;
        }
    }

    Ok(qr_codes)
}

fn calculate_hash<T: Hash>(t: &T) -> u64 {
    let mut s = DefaultHasher::new();
    t.hash(&mut s);
    s.finish()
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);
    }
}
