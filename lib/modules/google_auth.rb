module GoogleServices

  class Table

    def self.define_spreadsheet(user)
      google_drive_session = GoogleDrive.login_with_oauth(user.oauth_token)
      spreadsheet = google_drive_session.spreadsheet_by_title("FoodAudit")
      if spreadsheet
        ws = spreadsheet.worksheets[0]
      else
        spreadsheet = google_drive_session.create_spreadsheet(title = "FoodAudit")
        ws = spreadsheet.worksheets[0]
        ws[1, 1] = "Дата"
        ws[1, 2] = "Заказ"
        ws[1, 3] = "Сумма"
        ws.save
      end
      ws
    end

    def self.save_order(ws, order_date, order_list, price_counter)
      count = ws.rows.length + 1
      ws[count, 1] = order_date
      ws[count, 2] = order_list.join(', ')
      ws[count, 3] = "#{price_counter} грн."
      ws.save
    end

  end

end