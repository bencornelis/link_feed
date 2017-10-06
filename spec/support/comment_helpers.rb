def create_comment(days_ago:, shares:)
  Timecop.freeze(days_ago.days.ago) do
    create :comment_with_shares, shares_count: shares
  end
end