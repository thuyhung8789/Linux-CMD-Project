#Task1. sort by date release
csvsort -c release_date -r tmdb-movies.csv > task1_sorted_by_date.csv


#task2.Lọc ra các bộ phim có đánh giá trung bình trên 7.5 rồi lưu ra một file mới
csvgrep -c vote_average -r '^(7\.[6-9]|[8-9]|10)' tmdb-movies.csv >task2_vote_avarage_7.5.csv

echo "task 3-4"> task3_8_result.txt
awk 'BEGIN {
    FPAT = "([^,]*)|(\"[^\"]*\")"; # define csv delimeter
    # set variable
    max_rev = 0;
    max_title = "";
    total_revenue = 0;


    # triger parameter
    min_rev = 999999999999;
    min_title = "";
}
NR>1 {
    gsub(/"/, "", $5);      # xoa dau ngoac neu co
    current_rev = $5 + 0;   # set number
    total_revenue += ($5 + 0);
    # 1. Doanh so lon nhat
    if (current_rev > max_rev) {
        max_rev = current_rev;
        max_title = $6;     #  original_title
    }

    # 2. Lay doanh thu nho nhat >1
    if (current_rev > 0 && current_rev < min_rev) {
        min_rev = current_rev;
        min_title = $6;     # original_title
    }
}
END {
    print "=== DOANH THU LON NHAT ===";
    print "original_title: " max_title;
    print "revenue: $" max_rev;
    print "";
    print "=== DOANH THU NHO NHAT (>0) ===";
    print "original_title: " min_title;
    print "revenue: $" min_rev;
    print "=====================================";
    print " Tong doanh thu ";
    print "=====================================";
    # su dung printf tranh hien thi dang so mu e
    printf "Sum: $%.2f\n", total_revenue;
}' tmdb-movies.csv >> task3_8_result.txt

awk 'BEGIN {
    # Define csv
    FPAT = "([^,]*)|(\"[^\"]*\")";
    OFS = ",";
}
NR==1 {
    # tao header cho bang result
    print "Rank", "Original_Title", "Budget", "Revenue", "Profit";
    next;
}
{
    #Xoa dau ky tu thua
    gsub(/"/, "", $4);
    gsub(/"/, "", $5);

    bg = $4 + 0; # force number cost
    rv = $5 + 0; # force number revenue

    #  Loc bo data
    if (rv > 0 && bg > 0) {
        profit = rv - bg;
        # In ra màn hình tạm: Lợi nhuận, Tên phim, Chi phí, Doanh thu
        print profit, $6, bg, rv;
    }
}' tmdb-movies.csv | sort -t, -k1,1nr | head -n 10 | awk -F, '{
    #format result
    printf "%-2d | %-35s | cost: $%-12\033[0m | Doanh thu: $%-12\033[0m | Loi Nhuan: $%\033[1;32m%d\033[0m\n", NR, $2, $3, $4, $1
}'>> task3_8_result.txt

#task6-7

echo "task6-7" >>task3_8_result.txt
echo "=====DAO DIEN CO NHIEU PHIM NHAT=====" >> task3_8_result.txt 
awk 'BEGIN { FPAT = "([^,]*)|(\"[^\"]*\")" } NR>1 {
    gsub(/"/, "", $9); # Xóa dấu ngoặc kép ở cột director (cột 3)
    split($9, directors, "|"); # Tách các đạo diễn nếu phim có đồng đạo diễn
    for (i in directors) {
        if (directors[i] != "") print directors[i];
    }
 
}' tmdb-movies.csv | sort | uniq -c | sort -nr | head -n 1 >> task3_8_result.txt


echo "=====DIEN VIEN DONG NHIEU PHIM NHAT=====" >> task3_8_result.txt
awk 'BEGIN { FPAT = "([^,]*)|(\"[^\"]*\")" } NR>1 {
    gsub(/"/, "", $7); # Xóa dấu ngoặc kép ở cột cast (cột 8)
    split($7, actors, "|"); # Tách nhỏ từng diễn viên tham gia phim đó
    for (i in actors) {
        if (actors[i] != "") print actors[i];
    }
}' tmdb-movies.csv | sort | uniq -c | sort -nr | head -n 1 >> task3_8_result.txt


echo "=====THONG KE THE LOAI PHIM===== " >>task3_8_result.txt
awk 'BEGIN { 
    FPAT = "([^,]*)|(\"[^\"]*\")"; # Định nghĩa cấu trúc cột chuẩn CSV
} 
NR>1 {
    gsub(/"/, "", $14); # Xóa dấu ngoặc kép ở cột genres (cột số 2)
    split($14, genre_list, "|"); # Tách chuỗi thể loại theo dấu "|"
    for (i in genre_list) {
        if (genre_list[i] != "") print genre_list[i];
    }
}' tmdb-movies.csv | sort | uniq -c | sort -nr | awk '{
    # Định dạng lại văn bản để ghi vào file .txt cho đẹp mắt
    printf "- Thể loại: %-20s | Số lượng: %s phim\n", $2, $1
}' >>task3_8_result.txt
