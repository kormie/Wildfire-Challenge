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
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
  
  def feed
    @feed ||= graph.get_connections(uid, 'feed')
  end
  
  def feed_comments
    @feed_comments ||= feed.each
  end
  
  def friends
    @friends ||= graph.get_connections(uid, 'friends')
  end
  
  def friends_by_name
    @friends_by_name ||= friends.sort_by {|f| f['name']}
  end
end
