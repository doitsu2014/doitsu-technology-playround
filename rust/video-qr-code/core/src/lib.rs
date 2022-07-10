use opencv::{core, highgui, imgproc, objdetect, prelude::*, types, videoio, Result};
use std::{
    collections::{hash_map::DefaultHasher, HashMap},
    hash::{Hash, Hasher},
};

struct Configuration {
    is_debug: bool,
}

pub fn get_qr_codes_from_video(video_file_path: &str, period: f64) -> Result<HashMap<u64, String>> {
    let configuration = Configuration { is_debug: true };

    let mut qr_detector = objdetect::QRCodeDetector::default()?;
    let mut res = types::VectorOfPoint::new();
    // let mut capture = videoio::VideoCapture::from_file(video_file_path, videoio::CAP_PROP_FRAME_COUNT)?;

    println!("loading video path: {}", video_file_path);
    let mut camera = videoio::VideoCapture::from_file(video_file_path, videoio::CAP_ANY)?;

    let total_of_frames = camera.get(videoio::CAP_PROP_FRAME_COUNT)?;
    let fps = camera.get(videoio::CAP_PROP_FPS)?;
    let duration = total_of_frames / fps;
    let number_of_parts_by_period = (duration / period).round() as u64;
    let number_of_frames_in_period = (fps * period).round() as u64;
    println!("Capturing Video's duration: {}", duration);
    println!("Period: {} (s)", period);
    println!(
        "Number of parts of capturing video when it is divided in period: {}",
        number_of_parts_by_period
    );
    println!(
        "Number of frames in period: {}",
        number_of_frames_in_period
    );

    let mut img = Mat::default();
    let mut recqr = Mat::default();
    let mut qr_codes: HashMap<u64, String> = HashMap::new();

    for part in 0..number_of_parts_by_period {
        println!("Capturing part {}", part);
        let begin_index = (part * number_of_frames_in_period);
        camera.set(videoio::CAP_PROP_POS_FRAMES, begin_index as f64)?;
        for i in 0..number_of_frames_in_period {
            camera.read(&mut img)?;
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
                let winname = "QR Code";
                highgui::named_window(winname, highgui::WINDOW_NORMAL)?;
                if recqr.size()?.width > 0 {
                    highgui::imshow(winname, &recqr)?;
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

                highgui::imshow(winname, &img)?;
                let key = highgui::wait_key(1)?;
                if key == 'q' as i32 {
                    break;
                }
            }
        }
    }

    println!("End of capture task");
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
