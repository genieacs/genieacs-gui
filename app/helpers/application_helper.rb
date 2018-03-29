module ApplicationHelper
  def self.diff_hashes(hash1, hash2)
    (hash2.to_a - hash1.to_a & hash2.to_a).to_h
  end
end