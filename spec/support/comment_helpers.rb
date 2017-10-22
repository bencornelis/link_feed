def create_comment(days_ago:, shares:, badgings: 0)
  Timecop.freeze(days_ago.days.ago) do
    create :comment_with_shares_and_badgings,
           shares_count: shares,
           badgings_count: badgings
  end
end