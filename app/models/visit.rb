class Visit < ActiveRecord::Base
  def self.record_visit!(user, shortened_url)
    submitter_id = user.id
    shortened_url_id = shortened_url.id
    create(submitter_id: submitter_id, shortened_url_id: shortened_url_id)
  end
  
  belongs_to(
    :submitter,
    primary_key: :id,
    foreign_key: :submitter_id,
    class_name: "User"
  )
  
  belongs_to(
    :shortened_url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: "ShortenedUrl"
  )
  
end