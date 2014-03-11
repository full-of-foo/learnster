attributes :id, :item_id, :event, :created_at

node do |version|
    {
        created_at_formatted: version.created_at.strftime("%H:%M %d/%m/%Y")
    }
end

node(:version_word_count, :if => lambda { |version| version.reify }) do |version|
  version.item.version.reify.wiki_word_count()
end

node(:is_live, :if => lambda { |version| version.reify }) do |version|
  version.item.version.reify.live?()
end
