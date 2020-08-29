package com.gwoekga.server.datatype;

public class Subscribe {
    private String master;
    private String slave;
    private boolean push;

    public String getMaster() {
        return master;
    }

    public void setMaster(String master) {
        this.master = master;
    }

    public String getSlave() {
        return slave;
    }

    public void setSlave(String slave) {
        this.slave = slave;
    }

    public boolean isPush() {
        return push;
    }

    public void setPush(boolean push) {
        this.push = push;
    }

    @Override
    public String toString() {
        return "Subscribe{" +
                "master='" + master + '\'' +
                ", slave='" + slave + '\'' +
                ", push=" + push +
                '}';
    }
}