class ShortenedUrl < ActiveRecord::Base

  validates :short_url, presence: true, uniqueness: true
  validates :submitter_id, :long_url, presence: true

  def self.random_code
    # generate a 16-character base64 string
    random_code = SecureRandom::urlsafe_base64(12)
    # "The argument n specifies the length of the random length. The length
    #  of the result string is about 4/3 of n."
    # http://www.ruby-doc.org/stdlib-1.9.3/libdoc/securerandom/rdoc/SecureRandom.html#method-c-urlsafe_base64
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    user_id = user.id
    begin
      short_url = random_code
      self.create!(long_url: long_url,
                   short_url: short_url,
                   submitter_id: user_id)
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
  
  belongs_to(
    :submitter,
    primary_key: :id,
    foreign_key: :submitter_id,
    class_name: :User
  )
  
  has_many(
    :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit
  )
  
  has_many(
    :visitors, Proc.new { uniq },
    through: :visits,
    source: :submitter,
  )
  
  def num_clicks
    visits.count
  end
  
  def num_uniques
    visitors.count
  end
  
  def num_recent_uniques
    visitors.where( 'visits.created_at > ?', 10.minutes.ago ).count
  end
  
  
  
end
