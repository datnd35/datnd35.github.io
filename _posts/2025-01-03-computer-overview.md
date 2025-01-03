---
layout: post
title: "Computer overview"
categories: misc
---

# Overview cấu trúc một hệ thống máy tính

**_1. CPU (Central Processing Unit)_**

<img width="315" alt="image" src="https://github.com/user-attachments/assets/d5533c4a-9d01-47b9-b64c-fd92bd940b67">

- **_Gồm các lõi (cores) :_** Một CORE là một đơn vị xử lý độc lập trong bộ vi xử lý, có khả năng thực hiện các tác vụ tính toán và xử lý dữ liệu.
- **_Thực thi các lệnh cấp máy (machine level instructions):_** có thể hiểu và thực thi trực tiếp, là những lệnh cơ bản nhất mà CPU có thể xử lý, được viết dưới dạng mã nhị phân (0 và 1), và chúng tương ứng với các thao tác cơ bản như cộng, trừ, tải dữ liệu từ bộ nhớ, lưu dữ liệu vào bộ nhớ, so sánh, v.v.
- **_Có bộ nhớ đệm nhanh (Fast Caches):_** L1 (Level 1), L2 (Level 2), và L3 (Level 3), nếu dữ liệu không có trong bộ nhớ đệm, CPU sẽ phải truy xuất từ RAM hoặc thậm chí từ ổ đĩa cứng, điều này mất nhiều thời gian hơn.
- **_Mỗi lõi có tốc độ xung nhịp (clock speed):_** mỗi `CORE` trong `CPU` đề cập đến tốc độ mà lõi đó có thể thực hiện các lệnh hoặc chu kỳ tính toán.

**_2. RAM_**

<img width="315" alt="image" src="https://github.com/user-attachments/assets/f53e1029-0287-4217-be82-102beaad3709">

- Nhanh nhưng dễ thay đổi (Volatile)
- Lưu trữ trạng thái và dữ liệu của các tiến trình
- Có dung lượng hạn chế
- Chậm hơn bộ nhớ cache của CPU
- Stack, Heap,...

**_3. Ổ Đĩa - storage_**

<img width="480" alt="image" src="https://github.com/user-attachments/assets/b8264f07-69f2-4e52-b1a2-b5ed68571322">

- Lưu trữ lâu dài
- Chậm hơn RAM
- HDD, SSD

**_4. Network_**

<img width="342" alt="image" src="https://github.com/user-attachments/assets/793da911-c7f8-400e-b427-2e2a30c790b7">

- Giao tiếp với các máy chủ khác
- NIC (Network Interface Controller): Bộ điều khiển giao diện mạng
- Cài đặt giao thức: Triển khai các giao thức mạng

**_5. Kernel_**

- Cốt lõi của hệ điều hành (OS)

**_6. File System_**

**_7. Program vs Process_**

**_8. Process Management_**

**_9. User space vs Kernel Space_**

**_10. Device Drivers_**

**_11. System Calls_**

# OS (Operating System) Hệ điều hành máy tính

- **_OS_** là phần mềm hệ thống quan trọng nhất trong máy tính.Nó quản lý phần cứng máy tính, và cung cấp các dịch vụ cơ bản để các ứng dụng phần mềm có thể hoạt động.
- **_Kernel (lõi hệ điều hành)_** là phần trung tâm và quan trọng nhất của một hệ điều hành, chịu trách nhiệm quản lý các tài nguyên hệ thống như bộ xử lý (CPU), RAM, các thiết bị ngoại vi (như ổ cứng, mạng) và các tác vụ cơ bản khác. Kernel đóng vai trò làm cầu nối giữa phần cứng và phần mềm, giúp các chương trình và ứng dụng có thể tương tác với phần cứng mà không cần phải biết chi tiết cách thức hoạt động của phần cứng đó.

- **Hệ điều hành cung cấp công cụ và giao diện người dùng** `(GUI` để dễ dàng tương tác với hệ thống, trong khi **_`kernel` hoạt động ở mức thấp hơn._**

**_Một số chức năng hay dịch vụ mà OS cung cấp_**

**_1. Quản lý phần cứng:_**

- Điều khiển các thành phần phần cứng như `CPU`, bộ nhớ `(RAM)`, ổ đĩa, bàn phím, chuột, màn hình, máy in, v.v.

**_2. Quản lý tập tin:_**

- Cho phép lưu trữ, truy xuất, và quản lý dữ liệu trên các ổ đĩa thông qua hệ thống tập tin `(File System)`.

**_3. Quản lý tiến trình:_**

- Điều khiển và phân phối tài nguyên cho các chương trình đang chạy (processes).
- Hỗ trợ đa nhiệm (multitasking) để nhiều chương trình có thể chạy cùng lúc.

**_4. Giao diện người dùng (UI):_**

- Cung cấp giao diện đồ họa `(GUI)` hoặc giao diện dòng lệnh `(CLI)` để người dùng dễ dàng tương tác với hệ thống.

**_5. Quản lý bảo mật:_**

- Đảm bảo dữ liệu và tài nguyên hệ thống được bảo vệ khỏi truy cập trái phép.

# Cấu trúc của một Process

## Program

- Mã nguồn được biên dịch và liên kết cho một CPU
- Tạo ra tệp thực thi (executable file)
- Chỉ hoạt động trên kiến trúc CPU đó
- Khi không chạy, chương trình tồn tại dưới dạng tệp thực thi
- Tồn tại trên ổ đĩa (SSD, HDD)

**_Ví dụ: Program trên máy tính là Google Chrome._**

- **_Mã nguồn:_** Được viết bằng C++, JavaScript, ....Nó được biên dịch để tương thích với kiến trúc CPU của máy tính (như x86 hoặc ARM).

- **_Biên dịch và liên kết:_** Khi tải và cài đặt `Google Chrome`, `Source code` của nó sẽ được biên dịch thành `machine code` và liên kết thành một tệp thực thi duy nhất `(ví dụ: chrome.exe trên Windows, .app trên macOS)`. Tệp này chứa tất cả mã máy cần thiết để chạy ứng dụng.

- **_Tệp thực thi:_** Tệp `chrome.exe (trên Windows)` là tệp thực thi của `Google Chrome`. Khi bạn nhấp vào biểu tượng `Google Chrome`, hệ điều hành sẽ gọi tệp này và chương trình bắt đầu chạy.

- **_Kiến trúc CPU:_** `Google Chrome` được biên dịch để chạy trên các kiến trúc CPU phổ biến như x86 (cho máy tính để bàn) hoặc ARM (cho thiết bị di động). Mỗi kiến trúc CPU yêu cầu mã máy khác nhau, vì vậy tệp thực thi của Chrome có thể khác nhau trên các nền tảng khác nhau.

- **_Lưu trữ:_** Trước khi bạn mở Chrome, tệp thực thi của nó được lưu trữ trên ổ cứng hoặc SSD của máy tính trong thư mục cài đặt. Khi bạn mở ứng dụng, hệ điều hành tải tệp này vào RAM để thực thi.

## Quá trình (Process)

- Khi một chương trình được chạy, chúng ta có một quá trình.
- Quá trình sống trong RAM : Sau khi chương trình kết thúc, bộ nhớ mà quá trình chiếm dụng sẽ được giải phóng. Bộ nhớ của một quá trình có thể chứa nhiều thành phần như `stack, heap, và data section`, tất cả giúp quản lý và lưu trữ dữ liệu cần thiết cho quá trình thực thi của chương trình.
- Được nhận dạng duy nhất bằng một ID: Ví dụ, khi bạn mở một ứng dụng trên máy tính (chẳng hạn như trình duyệt web), hệ điều hành sẽ tạo ra một PID cho ứng dụng đó. Mỗi lần bạn mở một ứng dụng mới, nó sẽ nhận được một PID khác. Điều này giúp hệ điều hành theo dõi và quản lý các quá trình, chẳng hạn như khi cần dừng hoặc thay đổi trạng thái của một quá trình nào đó.

- Con trỏ lệnh / bộ đếm chương trình (Instruction pointer / Program counter).
- Khối điều khiển quá trình (Process Control Block - PCB).

<img width="933" alt="image" src="https://github.com/user-attachments/assets/b2ef5b1e-6254-4e36-8087-7afbeea1d333">

## Stack

<img width="395" alt="image" src="https://github.com/user-attachments/assets/86bfdca1-5251-4c26-bb0d-16250c23be93">

- Mỗi hàm có các biến cục bộ: Đây là những biến chỉ tồn tại trong phạm vi của hàm đó. Khi hàm được gọi, các biến này sẽ được tạo ra và khi hàm kết thúc, chúng sẽ bị hủy.
- Mỗi hàm nhận một khung (frame).
- Stack phát triển từ trên xuống dưới.
- Không gian stack có hạn.

**_Stack Pointer_** : là một thanh ghi (register) trong CPU dùng để theo dõi vị trí hiện tại của "đỉnh" stack trong bộ nhớ. Stack là một vùng bộ nhớ đặc biệt được sử dụng để lưu trữ các thông tin như biến cục bộ, địa chỉ trả về, và các tham số của hàm khi chương trình đang thực thi.

**_Stack và CPU_**

- **_CPU_** cần lưu trữ thông tin liên quan đến hàm như các tham số, địa chỉ trả về (nơi tiếp tục thực thi sau khi hàm kết thúc) **_trách nhiệm của nó chỉ là tính toán_**, và các biến cục bộ. Tất cả những thông tin này sẽ được đẩy (push) lên stack.

## Heap

- Khu vực Heap
- Lưu trữ dữ liệu lớn
- Duy trì cho đến khi bị xóa rõ ràng
- Tất cả các hàm đều có thể truy cập
- Dữ liệu động, phát triển từ thấp đến cao
- Xem lại bài JAVASCIPT
