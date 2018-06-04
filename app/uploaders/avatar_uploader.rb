class AvatarUploader < ImageUploader

  # Choose what kind of storage to use for this uploader:
  process resize_to_fit: [150, 150]

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [50, 50]
  end

end
