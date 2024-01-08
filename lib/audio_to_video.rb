# Videos for your Songs
class AudioToVideo
  def self.audio_to_video(audio, image: "./black-background.webp")
    # Supports Files or ActiveStorage::Attachment
    loop_option = if image.blob.content_type.downcase.include?("gif")
      "-ignore_loop 0" 
    else
      "-loop 1"
    end

    directory = 'tmp/audio_to_video'
    # Create the directory if it doesn't exist
    Dir.mkdir(directory) unless File.directory?(directory)

    output_path = Rails.root.join("#{directory}/audio_#{Time.zone.now.strftime("%s_%m_video")}.mp4")

    audio.open do |local_audio|
      image.open do |local_image|
        command = "ffmpeg #{loop_option} -i #{local_image.path} -i #{local_audio.path} -c:v libx264 -tune stillimage -c:a aac -strict experimental -b:a 192k -shortest #{output_path}"
        system(command)
      end
    end
    output_path
  end
end