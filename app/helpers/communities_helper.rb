module CommunitiesHelper
    
    def channel_collection(community)
        community.text_channels.map do |channel|
            [channel[:name], channel[:id]]
        end
    end
    
    def role_collection
        Role.all.reject{ |role| role.key == 'owner'}.map do |role|
            [role.label, role.key]
        end
    end

    def community_icon(c)
        if c.picture.attached?
            image_tag url_for(c.picture), class: 'community-icon'
        else
            image_tag 'community_default.png', class: 'community-icon'
        end
    end

    def badge(style, role_assignment)
        trash_icon = content_tag(:i, '', class: ["fas fa-trash-alt", "ml-2"])
        delete = link_to trash_icon,
                unassign_role_communities_path(id: role_assignment.discord_role.community.id,
                    dc_role_id: role_assignment.discord_role.id,
                    assignment_id: role_assignment.id), remote: true, method: :post, style: 'display: none', class: 'role-destroy'
                    
        badge_element(style, role_assignment.role.key) do
            [role_assignment.role.label, delete].join.html_safe
        end
    end

    def badge_element(style, key)
        content_tag(:span, class: "badge badge-pill badge-#{style} badge-role-#{key}") do
            yield
        end
    end

    def role_badge(role_assignment: nil, role: nil)
        if role
            style = role_style[role.key.to_sym]
            badge_element(style.nil? ? :secondary : style, role.key) do
                role.label.html_safe
            end
        elsif role_assignment
            badge = badge(role_style[role_assignment.role.key.to_sym],
                role_assignment)
            return badge(:secondary, role_assignment) if badge.nil?
            badge
        end
    end

    def role_style
        {
            admin: :danger,
            member: :primary,
            owner: :warning
        }
    end
end
