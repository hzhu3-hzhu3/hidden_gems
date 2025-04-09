Rails.application.config.after_initialize do
  next unless defined?(ActiveStorage::Blob)

  next if ActiveStorage::Blob.respond_to?(:build_after_unfurling)

  ActiveStorage::Blob.class_eval do
    unless method_defined?(:build_after_unfurling)
      def self.build_after_unfurling(key: nil, io: nil, filename: nil,
                                     content_type: nil, metadata: nil,
                                     service_name: nil, identify: true, record: nil)
        blob = build(key: key, filename: filename, content_type: content_type,
                     metadata: metadata, service_name: service_name)
        blob.unfurl(io, identify: identify)
        blob
      end
    end

    unless method_defined?(:image?)
      def image?
        return false if content_type.blank?
        content_type.start_with?("image/")
      end
    end

    attr_accessor :identified unless method_defined?(:identified=)

    unless method_defined?(:identified?)
      def identified?
        self.identified == true
      end
    end

    unless method_defined?(:identify_without_saving)
      def identify_without_saving
        self.identified = true
      end
    end

    unless method_defined?(:unfurl)
      def unfurl(io, identify:)
        self.byte_size = io.size
        self.checksum  = compute_checksum_in_chunks(io)

        if identify && self.content_type.nil?
          self.content_type = Marcel::MimeType.for(io, name: filename.to_s, declared_type: content_type)
        end

        if image?
          begin
            analyzer = ActiveStorage::Analyzer::ImageAnalyzer.new(self)
            self.metadata = analyzer.metadata
          rescue => e
          end
        end
      end
    end

    unless method_defined?(:compute_checksum_in_chunks)
      def compute_checksum_in_chunks(io)
        OpenSSL::Digest::MD5.new.tap do |checksum|
          while (chunk = io.read(5.megabytes))
            checksum << chunk
          end
          io.rewind
        end.base64digest
      end
    end

  end
end
