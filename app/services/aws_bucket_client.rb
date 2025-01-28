class AwsBucketClient

  def self.client
    credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    client = Aws::S3::Client.new(
      region:  ENV['AWS_REGION'],
      credentials: credentials
    )
    client
  end

  def self.bucket bucket_name, options={}
    unless bucket_exists? bucket_name
      client.create_bucket bucket: bucket_name, create_bucket_configuration: { location_constraint: ENV['AWS_REGION']}
      client.put_public_access_block bucket: bucket_name, public_access_block_configuration: { ignore_public_acls: true }
    end
    Aws::S3::Bucket.new(bucket_name)
  end

  def self.object bucket_name, basename, extension=nil, path=nil
    filename = file_url_for basename, extension, path
    bucket(bucket_name).object filename
  end

  def self.get_object bucket_name, basename, extension=nil, path=nil
    filename = file_url_for basename, extension, path
    client.get_object bucket: bucket_name, key: filename
  end

  def self.create_object bucket_name, basename, extension=nil, path=nil
    filename = file_url_for basename, extension, path
    client.put_object bucket: bucket_name, key: filename, content_type: 'application/csv'
    object bucket_name, basename, extension, path
  end

  def self.back_up_object bucket_name, basename, extension=nil, path=nil
    o = object bucket_name, basename, extension, path
    basename_ts = basename_with_timestamp basename, o.last_modified.in_time_zone('Pacific Time (US & Canada)')
    filename_ts = file_url_for basename_ts, extension, path
    client.put_object bucket: bucket_name, key: filename_ts, content_type: 'application/csv'
    o.copy_to bucket: bucket_name, key: filename_ts, multipart_copy: multipart_copy(o.size)
    object bucket_name, basename_ts, extension, path
  end

  def self.bucket_exists? bucket_name
    client.list_buckets.buckets.pluck(:name).include? bucket_name
  end

  def self.object_exists? bucket_name, basename, extension=nil, path=nil
    object(bucket_name, basename, extension, path).exists?
  end

  def self.multipart_copy size
    return true if size > 5242880
    false
  end

  def self.basename_with_timestamp filename, timestamp=Time.now
    "#{filename}.#{timestamp.to_s.gsub(' ', '_')}"
  end

  def self.file_url_for basename, extension=nil, path=nil
    url = basename
    url = "#{basename}.#{extension}" if extension
    url = "#{path}/#{url}" if path
    url
  end

end