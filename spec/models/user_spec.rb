require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
  end

  describe 'retrieving likes' do
    before do
      @likes = [
        {
          "name" => "The Office",
          "category" => "Tv show",
          "id" => "6092929747",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Flight of the Conchords",
          "category" => "Tv show",
          "id" => "7585969235",
          "created_time" => "2010-08-22T06:33:56+0000"
        },
        {
          "name" => "Wildfire Interactive, Inc.",
          "category" => "Product/service",
          "id" => "36245452776",
          "created_time" => "2010-06-03T18:35:54+0000"
        },
        {
          "name" => "Facebook Platform",
          "category" => "Product/service",
          "id" => "19292868552",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Twitter",
          "category" => "Product/service",
          "id" => "20865246992",
          "created_time" => "2010-05-02T14:07:10+0000"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'likes').once.and_return(@likes)
    end

    describe '#likes' do
      it 'should retrieve the likes via the graph api' do
        @user.likes.should == @likes
      end

      it 'should memoize the result after the first call' do
        likes1 = @user.likes
        likes2 = @user.likes
        likes2.should equal(likes1)
      end
    end

    describe '#likes_by_category' do
      it 'should group by category and sort categories and names' do
        @user.likes_by_category.should == [
          ["Product/service", [
            {
              "name" => "Facebook Platform",
              "category" => "Product/service",
              "id" => "19292868552",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Twitter",
              "category" => "Product/service",
              "id" => "20865246992",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Wildfire Interactive, Inc.",
              "category" => "Product/service",
              "id" => "36245452776",
              "created_time" => "2010-06-03T18:35:54+0000"
            }
          ]],
          ["Tv show", [
            {
              "name" => "Flight of the Conchords",
              "category" => "Tv show",
              "id" => "7585969235",
              "created_time" => "2010-08-22T06:33:56+0000"
            },
            {
              "name" => "The Office",
              "category" => "Tv show",
              "id" => "6092929747",
              "created_time" => "2010-05-02T14:07:10+0000"
            }
          ]]
        ]
      end
    end
  end
  
  describe "retrieving friends" do
    before do
      @friends = [
          {
            "name" => "Danny Gornetzki",
            "id" => "2405339"
          },
          {
            "name" => "Adam Eisenstein",
            "id" => "2405857"
          },
          {
            "name" => "David Schiff",
            "id" => "2405974"
          },
          {
            "name" => "Ryan McIntosh",
            "id" => "2406480"
          },
          {
            "name" => "Andrew Stern",
            "id" => "2406566"
          }
        ]
      @graph.should_receive(:get_connections).with(@uid, 'friends').once.and_return(@friends)
    end
    describe "#friends" do
      it "fetches the friends via the graph api" do
        @user.friends.should == @friends
      end
      it "memoizes the result after the first call" do
        friends1 = @user.friends
        friends2 = @user.friends
        friends2.should be(friends1)
      end
    end
  end

  describe "feed" do
    before do
      @feed = [
        {
              "id" => "100000359811554_176100665758504",
              "from" => {
                "name" => "David Kormushoff",
                "id" => "100000359811554"
              },
              "message" => "The age of student driven education has begun...",
              "picture" => "https://s-external.ak.fbcdn.net/safe_image.php?d=AQAlPcjUKey5p27S&w=90&h=90&url=http\u00253A\u00252F\u00252Fjotlocker.com\u00252Fimages\u00252Flogo.png\u00253F1295265817",
              "link" => "http://jotlocker.com/",
              "name" => "Jot Locker",
              "caption" => "jotlocker.com",
              "icon" => "https://s-static.ak.facebook.com/rsrc.php/v1/yD/r/aS8ecmYRys0.gif",
              "type" => "link",
              "created_time" => "2011-01-17T13:49:43+0000",
              "updated_time" => "2011-01-21T18:57:16+0000",
              "likes" => {
                "data" => [
                  {
                    "name" => "Ryan McIntosh",
                    "id" => "2406480"
                  },
                  {
                    "name" => "Nancy Denney Essex",
                    "id" => "514563928"
                  },
                  {
                    "name" => "Adam Eisenstein",
                    "id" => "2405857"
                  },
                  {
                    "name" => "Grant Anderson",
                    "id" => "2412465"
                  }
                ],
                "count" => 5
              },
              "comments" => {
                "data" => [
                  {
                    "id" => "100000359811554_176100665758504_2257851",
                    "from" => {
                      "name" => "Vanessa Bicicchi",
                      "id" => "22901354"
                    },
                    "message" => "Congrats!! The logo looks great!",
                    "created_time" => "2011-01-21T04:45:52+0000"
                  },
                  {
                    "id" => "100000359811554_176100665758504_2261490",
                    "from" => {
                      "name" => "Ryan McIntosh",
                      "id" => "2406480"
                    },
                    "message" => "a new age has begun",
                    "created_time" => "2011-01-21T18:57:16+0000",
                    "likes" => 1
                  }
                ],
                "count" => 2
              }
            }
        ]
        @graph.should_receive(:get_connections).with(@uid, 'feed', {limit: 100}).once.and_return(@feed)
    end
    describe "messages" do
      it "returns a list of messages on the feed" do
        comments = [
            {
              "id"=>"100000359811554_176100665758504_2257851",
              "from"=> {
                "name"=>"Vanessa Bicicchi",
                "id"=>"22901354"
              },
              "message"=>"Congrats!! The logo looks great!",
              "created_time"=>"2011-01-21T04:45:52+0000"
                },
            {
              "id"=>"100000359811554_176100665758504_2261490",
              "from"=> {
                "name"=>"Ryan McIntosh",
                "id"=>"2406480"
              },
              "message"=>"a new age has begun",
              "created_time"=>"2011-01-21T18:57:16+0000",
              "likes"=>1
            }
        ]
        @user.wall_comments.should eq(comments)
      end

    end
  end

end
