# ESP32 Dimmable BLDC Fan Controller (ESPHome)

Dự án điều tốc (không chổi than/BLDC Fan) thông qua xung PWM Frequency (LEDC) trên vi điều khiển ESP32, tích hợp điều khiển mềm mượt bằng bộ mã hóa xoay EC11 (Rotary Encoder).

## Tính năng chính
- Giao diện thân thiện: Trình bày như một "Bóng đèn" (`light`) có thanh trượt độ sáng (0% đến 100%) trên Home Assistant, giúp bạn có thể dễ dàng tăng giảm tốc độ quạt (hoặc điều chỉnh tự động qua Automation dễ dàng).
- Thuật toán biên dịch `% độ sáng -> Hz` siêu tuyến tính và dập triệt để độ trễ cũng như nhiễu giật/nhảy ngược. 
- Mạch thiết kế đếm bằng **Int Counter (Bộ đếm nguyên thủy)** nhằm phản hồi tức thì mọi pha "bật ngửa" - xử lý cực mượt ngay cả khi bạn có quay núm EC11 hết tốc lực.

---

## 🛠 Cách nối dây (Sơ đồ Wiring ESP32 - EC11 - Fan Driver)

### 1. Nối dây Encoder EC11
| Board ESP32      | Chân mạch EC11 | Chức năng               |
|------------------|----------------|-------------------------|
| `3.3V`           | `+ / VCC`      | Cấp nguồn               |
| `GND`            | `GND`          | Nối đất chung           |
| `GPIO32`         | `CLK`          | Tín hiệu xung đồng hồ   |
| `GPIO33`         | `DT`           | Tín hiệu hướng quay     |
| `GPIO25`         | `SW`           | Nút nhấn (Turn On/Off)  |

### 2. Nối dây Quạt BLDC (Ví dụ chuẩn xuất PWM)
| Board ESP32      | Driver Quạt BLDC | Chức năng                               |
|------------------|------------------|-----------------------------------------|
| `GND`            | `GND`            | Bắt buộc phải **chung Mass** (GND)      |
| `GPIO26`         | `PWM / PWM_IN`   | Xuất tín hiệu xung tần số biến thiên    |

> **Lưu ý:** Duty cycle luôn được cấu hình chốt cứng ở mức 50% (Sóng vuông chuẩn). Chế độ điều khiển tốc độ phụ thuộc vào việc tăng/giảm **Tần số (Frequency/Hz)** từ `100Hz` đến `400Hz`.

---

## ⚙️ Các tham số tùy chỉnh nhanh (Trong mã YAML)
Phần `substitutions:` ở hệ thống đầu file cấu hình có thể can thiệp nhanh:

- `clk_pin`: Chọn lại chân GPIO xuất xung cho quạt.
- `default_frequency`: Nhịp Hz cơ sở nếu chẳng may ESPHome thiết lập sai (Nên để `150`).
- **`encoder_resolution:`** **(Đặc biệt lưu tâm)**
  - Mặc định là `1` để đảm bảo 1 khấc vặn tương đương 1 nấc thay đổi (3%).
  - Nếu linh kiện EC11 của bạn thuộc dòng khác và quay 1 khấc bị nảy số 4 lần, hãy thay số này thành `4` để thiết lập cơ chế chia 4 (Hardware Debouncing).

## 🚀 Trích lọc bảo mật (GitHub Upload)
File `.yaml` cung cấp tên là `github_template.yaml` đã được tôi loại bỏ tên WiFi, password cũng như làm sạch các thành phần local IP. Bạn có thể sử dụng template này để chia sẻ hoặc dùng làm template cho tất cả con ESP còn lại!
