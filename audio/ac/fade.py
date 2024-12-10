import os
from scipy.io import wavfile
import numpy as np

def apply_fade(input_file, output_file, fade_percent=0.1):
    """
    Apply fade-in and fade-out to a WAV file using SciPy.
    
    Parameters:
    - input_file: Path to the input WAV file
    - output_file: Path to save the processed WAV file
    - fade_percent: Percentage of audio duration to fade (default 10%)
    """
    # Read the audio file
    samplerate, data = wavfile.read(input_file)
    
    # Determine if the audio is mono or stereo
    if data.ndim == 1:
        # Mono audio
        total_samples = len(data)
        fade_samples = int(total_samples * fade_percent)
        
        # Create fade-in
        fade_in = np.linspace(0, 1, fade_samples, dtype=data.dtype)
        data[:fade_samples] = (data[:fade_samples] * fade_in).astype(data.dtype)
        
        # Create fade-out
        fade_out = np.linspace(1, 0, fade_samples, dtype=data.dtype)
        data[-fade_samples:] = (data[-fade_samples:] * fade_out).astype(data.dtype)
    
    else:
        # Stereo audio
        total_samples = data.shape[0]
        fade_samples = int(total_samples * fade_percent)
        
        # Create fade-in for each channel
        fade_in = np.linspace(0, 1, fade_samples, dtype=data.dtype)
        data[:fade_samples, 0] = (data[:fade_samples, 0] * fade_in).astype(data.dtype)
        data[:fade_samples, 1] = (data[:fade_samples, 1] * fade_in).astype(data.dtype)
        
        # Create fade-out for each channel
        fade_out = np.linspace(1, 0, fade_samples, dtype=data.dtype)
        data[-fade_samples:, 0] = (data[-fade_samples:, 0] * fade_out).astype(data.dtype)
        data[-fade_samples:, 1] = (data[-fade_samples:, 1] * fade_out).astype(data.dtype)
    
    # Write the processed audio to a new file
    wavfile.write(output_file, samplerate, data)

def process_folder(input_folder, output_folder=None, fade_percent=0.1):
    """
    Process all WAV files in a given folder.
    
    Parameters:
    - input_folder: Path to the folder containing WAV files
    - output_folder: Path to save processed files (optional)
    - fade_percent: Percentage of audio duration to fade (default 10%)
    """
    # Create output folder if not specified
    if output_folder is None:
        output_folder = os.path.join(input_folder, 'processed')
    
    # Create output folder if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)
    
    # Process each WAV file in the input folder
    for filename in os.listdir(input_folder):
        if filename.lower().endswith('.wav'):
            input_path = os.path.join(input_folder, filename)
            output_path = os.path.join(output_folder, filename)
            
            try:
                apply_fade(input_path, output_path, fade_percent)
                print(f"Processed: {filename}")
            except Exception as e:
                print(f"Error processing {filename}: {e}")

# Example usage
if __name__ == "__main__":
    # Specify the input folder containing WAV files
    input_folder = "letter_sounds"
    
    # Optional: Specify a different output folder
    output_folder = "letter_sounds_processed"
    
    # Process files with default 10% fade
    process_folder(input_folder, output_folder)
    
    # Optional: Customize fade percentage
    # process_folder(input_folder, fade_percent=0.05)  # 5% fade