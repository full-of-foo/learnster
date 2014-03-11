class WikiSubmission < Submission
  validates_presence_of :wiki_markup
  has_paper_trail  on: [:update], only: [:wiki_markup, :notes]

  def wiki_word_count
    Nokogiri::HTML(self.wiki_markup).inner_text.downcase.scan(/[\w']+/).length
  end
end
