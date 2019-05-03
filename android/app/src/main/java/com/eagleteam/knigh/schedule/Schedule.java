package com.eagleteam.knigh.schedule;


public class Schedule {
    private int id;
    private String maMon, tenMon, thoiGian, ngay, diaDiem, hinhThuc, giaoVien, loaiLich, soBaoDanh;

    public Schedule(int id, String maMon, String tenMon, String thoiGian, String ngay, String diaDiem, String hinhThuc, String giaoVien, String loaiLich, String soBaoDanh) {
        this.id = id;
        this.maMon = maMon;
        this.tenMon = tenMon;
        this.thoiGian = thoiGian;
        this.ngay = ngay;
        this.diaDiem = diaDiem;
        this.hinhThuc = hinhThuc;
        this.giaoVien = giaoVien;
        this.loaiLich = loaiLich;
        this.soBaoDanh = soBaoDanh;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Schedule(){}

    public Schedule(String tenMon, String thoiGian, String diaDiem, String giaoVien) {
        this.tenMon = tenMon;
        this.thoiGian = thoiGian;
        this.diaDiem = diaDiem;
        this.giaoVien = giaoVien;
    }

    public Schedule(String tenMon, String thoiGian, String diaDiem, String hinhThuc, String loaiLich) {
        this.tenMon = tenMon;
        this.thoiGian = thoiGian;
        this.diaDiem = diaDiem;
        this.hinhThuc = hinhThuc;
        this.loaiLich = loaiLich;
    }

    public Schedule(String maMon, String tenMon, String thoiGian, String ngay, String diaDiem, String hinhThuc, String giaoVien, String loaiLich, String soBaoDanh) {
        this.maMon = maMon;
        this.tenMon = tenMon;
        this.thoiGian = thoiGian;
        this.ngay = ngay;
        this.diaDiem = diaDiem;
        this.hinhThuc = hinhThuc;
        this.giaoVien = giaoVien;
        this.loaiLich = loaiLich;
        this.soBaoDanh = soBaoDanh;
    }

    public String getSoBaoDanh() {
        return soBaoDanh;
    }

    public void setSoBaoDanh(String soBaoDanh) {
        this.soBaoDanh = soBaoDanh;
    }

    public String getTenMon() {
        return tenMon;
    }

    public void setTenMon(String tenMon) {
        this.tenMon = tenMon;
    }

    public String getMaMon() {
        return maMon;
    }

    public void setMaMon(String maMon) {
        this.maMon = maMon;
    }

    public String getThoiGian() {
        return thoiGian;
    }

    public void setThoiGian(String thoiGian) {
        this.thoiGian = thoiGian;
    }

    public String getNgay() {
        return ngay;
    }

    public void setNgay(String ngay) {
        this.ngay = ngay;
    }

    public String getDiaDiem() {
        return diaDiem;
    }

    public void setDiaDiem(String diaDiem) {
        this.diaDiem = diaDiem;
    }

    public String getHinhThuc() {
        return hinhThuc;
    }

    public void setHinhThuc(String hinhThuc) {
        this.hinhThuc = hinhThuc;
    }

    public String getGiaoVien() {
        return giaoVien;
    }

    public void setGiaoVien(String giaoVien) {
        this.giaoVien = giaoVien;
    }

    public String getLoaiLich() {
        return loaiLich;
    }

    public void setLoaiLich(String loaiLich) {
        this.loaiLich = loaiLich;
    }
}