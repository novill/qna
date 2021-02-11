module ApplicationHelper
  def cache_key_for(res)
    ['user',
     current_user.try(:id).to_i,
     res.class.name,
     res.id,
     res.updated_at.to_i
    ].join('-')
  end
end
