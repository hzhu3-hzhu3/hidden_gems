if defined?(ActiveStorage)
  class ActiveStorage::Attachment < ActiveRecord::Base
    def self.ransackable_attributes(auth_object = nil)
      ["blob_id", "created_at", "id", "name", "record_id", "record_type"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["blob", "record"]
    end
  end

  class ActiveStorage::Blob < ActiveRecord::Base
    def self.ransackable_attributes(auth_object = nil)
      ["byte_size", "checksum", "content_type", "created_at", "filename", "id", "key", "metadata", "service_name"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["attachments", "variant_records"]
    end
  end
end