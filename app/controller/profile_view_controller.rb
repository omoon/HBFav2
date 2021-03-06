# -*- coding: utf-8 -*-
class ProfileViewController < UIViewController
  attr_accessor :user

  def viewDidLoad
    super

    self.navigationItem.title = @user.name
    self.backGestureEnabled = true
    self.navigationItem.backBarButtonItem = UIBarButtonItem.titled("戻る")

    ## 背景
    view << UITableView.alloc.initWithFrame(view.bounds, style:UITableViewStyleGrouped)

    @dataSource = [
      {
        :title => nil,
        :rows  => [
          {
            :label         => "ブックマーク",
            :accessoryType => UITableViewCellAccessoryDisclosureIndicator,
            :action        => 'open_bookmarks'
          },
          {
            :label         => "フォロー",
            :accessoryType => UITableViewCellAccessoryDisclosureIndicator,
            :action        => 'open_timeline'
          },
        ]
      },
    ]

    @imageView = UIImageView.new.tap do |v|
      v.frame = [[10, 10], [48, 48]]
      v.layer.tap do |l|
        l.masksToBounds = true
        l.cornerRadius  = 5.0
      end
      v.setImageWithURL(@user.profile_image_url.nsurl, placeholderImage:nil)
      view << v
    end

    @nameLabel = UILabel.new.tap do |v|
      v.frame = [[68, 10], [200, 48]]
      v.font  = UIFont.boldSystemFontOfSize(18)
      v.text  = @user.name
      v.shadowColor = UIColor.whiteColor
      v.shadowOffset = [0, 1]
      v.backgroundColor = UIColor.clearColor
      view << v
    end

    @menuTable = UITableView.alloc.initWithFrame([[0, 59], self.view.bounds.size], style:UITableViewStyleGrouped).tap do |v|
      v.dataSource = v.delegate = self
      view << v
    end
  end

  def viewWillAppear(animated)
    super
    @menuTable.deselectRowAtIndexPath(@menuTable.indexPathForSelectedRow, animated:animated)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    id = "basis-cell"
    rowData = @dataSource[indexPath.section][:rows][indexPath.row]

    cell = tableView.dequeueReusableCellWithIdentifier(id) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:id)
    cell.textLabel.text = rowData[:label]

    if (color = rowData[:color])
      cell.textLabel.textColor = color
    end

    if (accessory = rowData[:accessoryType])
      cell.accessoryType = accessory
    end

    cell
  end

  def tableView(tableView, titleForHeaderInSection:section)
    if (title = @dataSource[section][:title])
      return title
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @dataSource[section][:rows].size
  end

  def numberOfSectionsInTableView (tableView)
    # @dataSource.size
    # ↓ ちょっとこの書き方はどうかなあ
    @dataSource.size
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    if (action = @dataSource[indexPath.section][:rows][indexPath.row][:action])
      self.send(action)
    end
  end

  def open_bookmarks
    self.navigationController.pushViewController(
      TimelineViewController.new.tap do |c|
        c.user  = user
        c.content_type = :bookmark
        c.title = user.name
      end,
      animated:true
    )
  end

  def open_timeline
    self.navigationController.pushViewController(
      TimelineViewController.new.tap do |c|
        c.user  = user
        c.title = user.name
      end,
      animated:true
    )
  end

  def dealloc
    NSLog("dealloc: " + self.class.name)
    super
  end
end
