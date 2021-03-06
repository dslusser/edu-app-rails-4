class SeedHelper
  class << self

    def seed_all
      data = JSON.parse(File.read("#{Rails.root}/data/seed_data.json"))

      data['tags'].each do |tag|
        Tag.where(name: tag["name"], short_name: tag["short_name"], context: tag["context"]).first_or_create
      end
    end
    
  end
end