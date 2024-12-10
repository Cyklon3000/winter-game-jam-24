import os
from pydub import AudioSegment

def concatenate_letter_sounds(input_string, input_folder, output_file='output.wav', overlap_percentage=0.5):
    """
    Concatenate .wav files for each letter in the input string with slight overlap.
    
    :param input_string: String containing letters to process (a-z, ä, ö, ü, ß)
    :param input_folder: Folder containing individual letter .wav files
    :param output_file: Name of the output .wav file
    :param overlap_percentage: Percentage of the first sound to overlap with the next sound
    """
    # Normalize the input string to lowercase
    input_string = input_string.lower()
    
    # List to store audio segments
    audio_segments = []
    
    # Process each letter
    for i, letter in enumerate(input_string):
        # Construct the file path for the current letter
        file_path = os.path.join(input_folder, f"{letter}.wav")
        
        # Check if the file exists
        if not os.path.exists(file_path):
            print(f"Warning: No .wav file found for letter '{letter}'. Skipping.")
            continue
        
        # Load the audio segment
        current_segment = AudioSegment.from_wav(file_path)
        
        # For subsequent letters, create an overlap
        if i > 0:
            # Calculate overlap duration
            overlap_duration = int(len(previous_segment) * overlap_percentage)
            
            # Adjust the current segment to start during the previous segment
            current_segment = current_segment.overlay(previous_segment, 
                                                      position=-overlap_duration)
        
        # Add to the list of segments
        audio_segments.append(current_segment)
        
        # Store the current segment for the next iteration
        previous_segment = current_segment
    
    # Concatenate all audio segments
    if audio_segments:
        final_audio = sum(audio_segments)
        
        # Export the final audio file
        final_audio.export(output_file, format="wav")
        print(f"Audio file created: {output_file}")
    else:
        print("No valid audio segments found.")

# Example usage
if __name__ == "__main__":
    # Example parameters
    input_string = "Hallo. Ich brauche deine Hilfe bei einer kleinen Unternehmung. Mir ist in letzter Zeit etwas kalt geworden."  # The string to convert to audio
    input_string = input_string.replace(" ", "").replace(".", "___")
    input_folder = "letter_sounds_processed"  # Folder containing individual letter .wav files
    output_file = "output.wav"  # Name of the output file
    
    # Call the function
    concatenate_letter_sounds(input_string, input_folder, overlap_percentage=0.3)