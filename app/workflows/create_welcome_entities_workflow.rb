class CreateWelcomeEntitiesWorkflow
  def run
    tenant = Current.tenant_or_raise! # check that Current Tenant is set
    owner = tenant.users.first

    # Create some Boards
    feature_board = Board.create!(
      name: 'Запрос функций',
      description: 'Это **доска**! Перейдите в Настройки сайта > Доски, чтобы настроить ее или добавить больше!',
      order: 0
    )
    bug_board = Board.create!(
      name: 'Отчеты об ошибках',
      description: 'Расскажите нам обо всех проблемах, с которыми вы столкнулись при использовании наших услуг!',
      order: 1
    )

    # Create some Post Statuses
    planned_post_status = PostStatus.create!(
      name: 'Запланировано',
      color: '#0096ff',
      order: 0,
      show_in_roadmap: true
    )
    in_progress_post_status = PostStatus.create!(
      name: 'В работе',
      color: '#9437ff',
      order: 1,
      show_in_roadmap: true
    )
    completed_post_status = PostStatus.create!(
      name: 'Завершено',
      color: '#6ac47c',
      order: 2,
      show_in_roadmap: true
    )
    rejected_post_status = PostStatus.create!(
      name: 'Отклонено',
      color: '#ff2600',
      order: 3,
      show_in_roadmap: false
    )

    # Create some Posts
    post1 = Post.create!(
      title: 'Это пример поста с отзывом, нажмите, чтобы узнать больше!',
      description: 'Пользователи могут отправлять отзывы, публикуя посты, подобные этому. Вы можете назначить **статус** каждому посту: этот, например, отмечен как «Запланировано». Помните, что вы можете настраивать статусы постов в разделе Настройки сайта > Статусы',
      board_id: feature_board.id,
      user_id: owner.id,
      post_status_id: planned_post_status.id
    )
    PostStatusChange.create!(
      post_id: post1.id,
      user_id: owner.id,
      post_status_id: planned_post_status.id
    )

    post2 = Post.create!(
      title: 'Есть несколько досок',
      description: 'Мы создали для вас две доски: «Запросы функций» и «Отчеты об ошибках», но вы можете добавлять или удалять столько, сколько захотите! Просто перейдите в Настройки сайта > Доски!',
      board_id: bug_board.id,
      user_id: owner.id
    )

    # Create some comments
    post1.comments.create!(
      body: 'Пользователи могут комментировать, чтобы выразить свое мнение! Как и в случае с сообщениями и описаниями досок, комментарии могут быть *Markdown* **отформатированы**',
      user_id: owner.id
    )

    # Set first board as root page
    TenantSetting.create!(root_board_id: feature_board.id)

    # Enable all default oauths
    OAuth.include_only_defaults.each do |o_auth|
      TenantDefaultOAuth.create!(o_auth_id: o_auth.id)
    end
  end
end