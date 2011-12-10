class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|like| like['name']}.group_by {|like| like['category']}.sort
  end
  
  def friends
    @friends ||= graph.get_connections(uid, 'friends')
  end
  
  def feed
    @feed ||= graph.get_connections(uid, 'feed', {limit: 1000})
  end
  
  def wall_comments
    @wall_comments ||= feed.collect do |post|
      post['comments']['data'] if post['comments']['count'] > 0
    end.flatten.compact
  end
end
